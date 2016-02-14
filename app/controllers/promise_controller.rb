module Guac
  class PromiseController < BaseController
    def get_create(req)
      return redirect('/login') unless authorized?(req)

      id = req.params['id'] || req.session['user_id']
      @user = UserRepository.find(id)
      render :create_promise
    end

    def get_register(req)
      render :register
    end

    def post_register(req)
      user = User.new(req.params['username'], req.params['email'], req.params['first_name'], req.params['last_name'], nil)
      UserRepository.create(user)
      redirect '/'
    end
  end
end
