module UserRepository
  extend self

  def create(user)
    statement = <<-SQL
      INSERT INTO users (
        `username`, `email`, `first_name`, `last_name`, `location`, `role`
      ) VALUES (
        ?, ?, ?, ?, ?, ?
      );
    SQL
    DB.execute statement,
        user.username, user.email, user.first_name,
        user.last_name, user.location, user.role
  end

  def find(id)
    columns, row = DB.execute2 "SELECT * FROM users WHERE id = ?;", id
    return unless row

    user_attributes = columns.zip(row).to_h
    wrap_user(user_attributes)
  end

  def all
    result = DB.execute2 "SELECT * FROM users;"
    column_names = result.first
    columns = result[1..-1]

    users = columns.collect { |x| wrap_user(column_names.zip(x).to_h) }
  end

  def find_by_username(username)
    columns, row = DB.execute2 "SELECT * FROM users WHERE username LIKE ?;", username
    return unless row

    user_attributes = columns.zip(row).to_h
    wrap_user(user_attributes)
  end

  def update(user)
    statement = <<-SQL
      UPDATE users
      SET
        username = ?,
        email = ?,
        first_name = ?,
        last_name = ?,
        location = ?,
        role = ?
      WHERE id = ?;
    SQL
    DB.execute statement,
        user.username, user.email, user.first_name,
        user.last_name, user.location, user.role,
        user.id
  end

  def delete(id)
    DB.execute "DELETE FROM users WHERE id = ?;", id
  end

  def wrap_user(user_attributes)
    User.new(
        user_attributes['username'],
        user_attributes['email'],
        user_attributes['first_name'],
        user_attributes['last_name'],
        user_attributes['location'],
        user_attributes['role'],
        user_attributes['id'],
      )
  end
end
