module Guac
  class CommentController < BaseController
    def post_comment(req)
      return Rack::Response.new(status = 401) unless authorized?(req)

      user_id = req.session['user_id']
      promise_id = req.params['promise_id']
      text = req.params['comment_text']
      comment = Comment.new(text, user_id, promise_id, 0)
      CommentRepository.create(comment)

      Rack::Response.new(body = [], status = 201)
    end

		def get_comments(req)
      return Rack::Response.new(status = 401) unless authorized?(req)

			promise_id = req.params['promise_id']
      comments = CommentRepository.get_by_promise_id(promise_id)

      Rack::response.new(status = 200, body = comments.to_json)
		end
  end
end
