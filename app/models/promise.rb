class Promise
  attr_accessor :id, :status, :title, :body, :completed_reference, :user_id

  NOT_STARTED = 0
  STARTED = 1
  BROKEN = 2
  FINISHED = 3

  def initialize(status, title, body, completed_reference, user_id, id = nil)
    @status = status
    @title = title
    @body = body
    @completed_reference = completed_reference
    @user_id = user_id
    @id = id
  end
end
