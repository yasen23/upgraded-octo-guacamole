module Guac
  class LoginController < BaseController
    def get_login(req)
      authorize(req)
      return redirect '/' unless !@authorized
      render :login
    end

    def post_login(req)
      authorize(req)
      return redirect '/' unless !@authorized

      if user = UserRepository.find_by_username(req.params['username'])
        req.session['user_id'] = user.id
        redirect '/show'
      else
        redirect '/login'
      end
    end

    def get_logout(req)
      autorize(req)
      return redirect '/login' unless @authorized

      req.session.clear
      redirect '/'
    end
  end
end
