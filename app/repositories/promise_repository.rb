module PromiseRepository
  extend self

  def create(promise)
    statement = <<-SQL
      INSERT INTO promises (
        `status`, `title`, `body`, `user_id`, `privacy`, `confirmed`
      ) VALUES (
        ?, ?, ?, ?, ?, ?
      );
    SQL
    DB.execute statement,
        promise.status, promise.title, promise.body, promise.user_id,
        promise.privacy, promise.confirmed
  end

  def find(id)
    columns, row = DB.execute2 "SELECT * FROM promises WHERE id = ?;", id
    return unless row

    promise = columns.zip(row).to_h
    wrap_promise(promise)
  end

  def find_by_user(user_id)
    result = DB.execute2 "SELECT * FROM promises WHERE user_id = ?;", user_id
    column_names = result.first
    columns = result[1..-1]

    promises = columns.collect { |x| wrap_promise(column_names.zip(x).to_h) }
  end

  def get_stats_for_user(user_id)
    statement = <<-SQL
      SELECT status, COUNT(*)
      FROM promises
      WHERE user_id=?
      GROUP BY status;
    SQL
    result = DB.execute2 statement, user_id
    Hash[result.drop 1]
  end

  def update(promise)
    statement = <<-SQL
      UPDATE promises
      SET
        status = ?,
        title = ?,
        body = ?,
        privacy = ?,
        completed_reference = ?,
        confirmed = ?
      WHERE id = ?;
    SQL
    DB.execute statement,
        promise.status, promise.title, promise.body,
        promise.privacy, promise.completed_reference,
        promise.confirmed, promise.id
  end

  def delete(id)
    DB.execute "DELETE FROM promise WHERE id = ?;", id
  end

  def wrap_promise(promise)
    Promise.new(
        promise['status'],
        promise['title'],
        promise['body'],
        promise['completed_reference'],
        promise['user_id'],
        promise['privacy'],
        promise['confirmed'],
        promise['id']
      )
  end
end
