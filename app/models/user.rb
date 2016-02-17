require 'jsonable'

class User
  include Jsonable

  ROLE_REGULAR = 0
  ROLE_ADMIN = 1

  attr_accessor :id, :username, :email, :first_name, :last_name, :location, :role

  def initialize(username, email, first_name, last_name, location, role, id = nil)
    @username = username
    @email = email
    @first_name = first_name
    @last_name = last_name
    @location = location
    @id = id
    @role = role
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
