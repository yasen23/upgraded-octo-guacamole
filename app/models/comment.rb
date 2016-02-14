class Comment
  attr_accessor :id, :timestamp, :text, :user_id, :promise_id, :score, :username

  def initialize(id = nil, timestamp = nil, username = nil, text, user_id, promise_id, score)
    @id = id
    @timestamp = timestamp
    @text = text
    @user_id = user_id
    @promise_id = promise_id
    @score = score
    @username = username
  end
end
