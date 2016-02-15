module Guac
  class BaseController
    def render(view_path)
      view_content = File.read("./app/views/#{view_path}.html.erb")
      Rack::Response.new ERB.new(view_content).result(binding)
    end

    def partial(view_path)
      view_content = File.read("./app/views/partials/_#{view_path}.erb")
      ERB.new(view_content).result(binding)
    end

    def redirect(path)
      response = Rack::Response.new()
      response.redirect(path)
      response.finish
    end

    def authorize(req)
      id = req.session['user_id']
      @authorized = !id.nil?
      if @authorized
        @current_user = UserRepository.find(id)
      end
    end

    def send_file(filename)
      path = "app/public/uploads/#{filename}"
      response = Rack::Response.new()
      response["Content-Type"] = ::MIME::Types.type_for(filename).first.to_s
      response.body = FileStreamer.new(path)
      response.finish
    end
  end
end
