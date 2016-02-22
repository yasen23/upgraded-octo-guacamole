require 'json'

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

      privacy = Integer(req.params['privacy'] || -1)
      if privacy != Promise::PUBLIC and privacy != Promise::PRIVATE
        return Rack::Response.new(status = "Invalid privacy setting.", code = 400)
      end

      promise = Promise.new(Promise::NOT_STARTED,
        req.params['title'],
        req.params['body'],
        nil,
        @current_user.id,
        privacy,
        Promise::NOT_CONFIRMED);
      PromiseRepository.create(promise)

      return redirect('/listPromises')
    end

    def get_rights(promise)
      if !@authorized
        return EditRights.new(false, false, false, promise.id)
      end

      if promise.confirmed == Promise::CONFIRMED
        return EditRights.new(false, false, false, promise.id)
      end

      confirm = (@current_user.role == User::ROLE_ADMIN) &&
          (promise.status == Promise::BROKEN || promise.status == Promise::FINISHED)

      if promise.user_id == @current_user.id
        return EditRights.new(true, true, confirm, promise.id)
      end

      if promise.privacy == Promise::PUBLIC
        return EditRights.new(false, true, confirm, promise.id)
      end

      return EditRights.new(false, false, confirm, promise.id)
    end

    def post_edit(req)
      authorize(req)
      params = JSON.parse(req.body.read)
      promise = PromiseRepository.find(params['promiseId'])
      rights = get_rights(promise)
      if not @authorized or !rights.edit
        return Rack::Response.new(status = "Not authorized.", code = 401) unless @authorized
      end

      promise.title = params['title']
      promise.body = params['body']
      promise.privacy = params['privacy']

      PromiseRepository.update(promise)
      updated = PromiseRepository.find(promise.id)
      return Rack::Response.new(body = updated.to_json, code = 201)
    end

    def post_update(req)
      authorize(req)
      params = JSON.parse(req.body.read)
      promise = PromiseRepository.find(params['promiseId'])
      rights = get_rights(promise)
      if not @authorized or !rights.update
        return Rack::Response.new(status = "Not authorized.", code = 401) unless @authorized
      end

      promise.status = params['status']
      promise.completed_reference = params['completedReference']
      PromiseRepository.update(promise)
      updated = PromiseRepository.find(promise.id)
      return Rack::Response.new(body = updated.to_json, code = 201)
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

    def get_confirm(req)
      authorize(req)
      if not @authorized
        return Rack::Response.new(body = "Not authorized.", status = 401)
      end

      promise = PromiseRepository.find(req.params['promiseId'])
      rights = get_rights(promise)
      if not rights.confirm
        return Rack::Response.new(body = "Not authorized.", status = 401)
      end

      if promise == nil
        return Rack::Response.new(body = "Promise not found.", status = 404)
      end

      promise.confirmed = Promise::CONFIRMED
      PromiseRepository.update(promise)
      return Rack::Response.new(body = promise.to_json, code = 201)
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

    def get_single_json(req)
      authorize(req)
      if not @authorized
        return Rack::Response.new(status = "Not authorized.", code = 401)
      end

      promise = PromiseRepository.find(req.params['promiseId'])
      return Rack::Response.new(body = promise.to_json, status = 200)
    end
  end
end
