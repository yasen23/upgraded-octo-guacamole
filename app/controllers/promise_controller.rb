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
