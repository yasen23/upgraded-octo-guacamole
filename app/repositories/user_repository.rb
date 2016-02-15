module UserRepository
  extend self

  def create(user)
    DB.execute <<-SQL
      INSERT INTO users (
        `username`, `email`, `first_name`, `last_name`, `location`
      ) VALUES (
        '#{user.username}', '#{user.email}', '#{user.first_name}', '#{user.last_name}', '#{user.location}'
      );
    SQL
  end

  def find(id)
    columns, row = DB.execute2 "SELECT * FROM users WHERE id = #{id};"
    return unless row

    user_attributes = columns.zip(row).to_h
    wrap_user(user_attributes)
  end

  def find_by_username(username)
    columns, row = DB.execute2 "SELECT * FROM users WHERE username LIKE '#{username}';"
    return unless row

    user_attributes = columns.zip(row).to_h
    wrap_user(user_attributes)
  end

  def update(user)
    DB.execute <<-SQL
      UPDATE users
      SET
        username = '#{user.username}',
        email = '#{user.email}',
        first_name = '#{user.first_name}',
        last_name = '#{user.last_name}',
        location = '#{user.location}'
      WHERE id = #{user.id};
    SQL
  end

  def delete(id)
    DB.execute "DELETE FROM users WHERE id = #{id};"
  end

  def wrap_user(user_attributes)
    User.new(
        user_attributes['username'],
        user_attributes['email'],
        user_attributes['first_name'],
        user_attributes['last_name'],
        user_attributes['location'],
        user_attributes['id'],
      )
  end
end
