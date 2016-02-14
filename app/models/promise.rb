class Promise
  attr_accessor :id, :status, :title, :body, :completed_reference, :user_id

  def initialize(status = 0, title, body, completed_reference, user_id, id = nil)
    @status = status
    @title = title
    @body = body
    @completed_reference = completed_reference
    @user_id = user_id
    @id = id
  end
end
