class EditRights
  include Jsonable
  attr_accessor :edit, :update, :promise_id

  def initialize(edit, update, promise_id)
    @edit = edit
    @update = update
    @promise_id = promise_id
  end
end
