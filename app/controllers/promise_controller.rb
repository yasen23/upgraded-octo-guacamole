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

      return redirect('/')
    end
  end
end
