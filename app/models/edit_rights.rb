class EditRights
  include Jsonable
  attr_accessor :edit, :update, :promise_id, :confirm

  def initialize(edit, update, confirm, promise_id)
    @edit = edit
    @update = update
    @confirm = confirm
    @promise_id = promise_id
  end
end
