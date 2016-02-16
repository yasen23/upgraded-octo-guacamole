module Guac
  class UserController < BaseController
    def get_show(req)
      authorize(req)
      return redirect '/login' unless @authorized

      id = req.params['id'] || req.session['user_id']
      @user = UserRepository.find(id)
      @stats = PromiseRepository.get_stats_for_user(id)
      render :show
    end

    def get_register(req)
      authorize(req)
      return redirect '/' unless !@authorized

      render :register
    end

    def get_all(req)
      authorize(req)
      if !@authorized
        return Rack::Response.new(status = "Not authorized.", code = 401)
      end

      users = UserRepository.all()
      return Rack::Response.new(body = users.to_json, code = 200)
    end

    def post_register(req)
      authorize(req)
      return redirect '/' unless !@authorized

      user = User.new(req.params['username'], req.params['email'], req.params['first_name'], req.params['last_name'], nil)
      UserRepository.create(user)
      redirect '/'
    end
  end
end
