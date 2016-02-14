module Guac
  class PromiseController < BaseController
    def get_create(req)
      return redirect('/login') unless authorized?(req)

      id = req.params['id'] || req.session['user_id']
      @user = UserRepository.find(id)
      render :create_promise
    end

    def post_create(req)
      return redirect('/login') unless authorized?(req)

      id = req.session['user_id']
      promise = Promise.new(Promise::NOT_STARTED, req.params['title'], req.params['body'], nil, id)
      PromiseRepository.create(promise)

      return redirect('/listPromises')
    end

		def get_list(req)
			return redirect('/loign') unless authorized?(req)

			id = req.params['id'] || req.session['user_id']
			@user = UserRepository.find(id)
			@promises = PromiseRepository.find_by_user(id)
      render :list_promises
		end

    def get_single(req)
      return redirect('/login') unless authorized?(req)

      id = req.params['id'] || req.session['user_id']
			@user = UserRepository.find(id)

      promise_id = req.params['promiseId']
      @promise = PromiseRepository.find(promise_id)
      render :promise_detail
    end
  end
end
