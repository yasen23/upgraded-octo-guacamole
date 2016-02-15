module Guac
  class PromiseController < BaseController
    def get_create(req)
      authorize(req)
      return redirect('/login') unless @authorized

      render :create_promise
    end

    def post_create(req)
      authorize(req)
      return redirect('/login') unless @authorized

      privacy = req.params['privacy']
      if privacy != Promise::PUBLIC and privacy != Promise::PRIVATE
        return Rack::Response.new(status = "Invalid privacy setting.", code = 400)
      end

      promise = Promise.new(Promise::NOT_STARTED,
        req.params['title'],
        req.params['body'],
        nil,
        @current_user.id,
        privacy);
      PromiseRepository.create(promise)

      return redirect('/listPromises')
    end

    def get_rights(promise)
      if !@authorized
        return EditRights.new(false, false, promise.id)
      end

      if promise.user_id == @current_user.id
        return EditRights.new(true, true, promise.id)
      end

      if promise.privacy == Promise::PUBLIC
        return EditRights.new(false, true, promise.id)
      end

      return EditRights.new(false, false, promise.id)
    end

    def poast_edit(req)
      authorize(req)
      promise = PromiseRepository.find(req.params['promiseId'])
      rights = get_rights(promise)
      if not @authorized or !rights.edit
        return Rack::Response.new(status = "Not authorized.", code = 401) unless @authorized
      end

      promise.status = req.params['status']
      promise.title = req.params['title']
      promise.body = req.params['body']
      promise.privacy = req.params['privacy']
      promise.completed_reference = req.params['completed_reference']

      PromiseRepository.update(promise)
      return Rack::Response.new(status = "Updated.", code = 201)
    end

    def post_update(req)
      authorize(req)
      promise = PromiseRepository.find(req.params['promiseId'])
      rights = get_rights(promise)
      if not @authorized or !rights.update
        return Rack::Response.new(status = "Not authorized.", code = 401) unless @authorized
      end

      promise.status = req.params['status']
      promise.completed_reference = req.params['completed_reference']
      PromiseRepository.update(promise)
      return Rack::Response.new(status = "Updated.", code = 201)
    end

    def get_promise_rights(req)
      authorize(req)
      if not @authorized
        return Rack::Response.new(status = "Not authorized.", code = 401)
      end

      promise = PromiseRepository.find(req.params['promiseId'])
      rights = get_rights(promise)
      return Rack::Response.new(body = rights.to_json, status = 200)
    end

		def get_list(req)
      authorize(req)
      return redirect('/login') unless @authorized

			id = req.params['id'] || req.session['user_id']
			@user = UserRepository.find(id)
			@promises = PromiseRepository.find_by_user(id)
      render :list_promises
		end

    def get_single(req)
      authorize(req)
      return redirect('/login') unless @authorized

      id = req.params['id'] || req.session['user_id']
			@user = UserRepository.find(id)

      promise_id = req.params['promiseId']
      @promise = PromiseRepository.find(promise_id)
      render :promise_detail
    end
  end
end
