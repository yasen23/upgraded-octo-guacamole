module PromiseRepository
  extend self

  def create(promise)
    DB.execute <<-SQL
      INSERT INTO promises (
        `status`, `title`, `body`, `user_id`, `privacy`
      ) VALUES (
        '#{promise.status}', '#{promise.title}', '#{promise.body}', '#{promise.user_id}', '#{promise.privacy}'
      );
    SQL
  end

  def find(id)
    columns, row = DB.execute2 "SELECT * FROM promises WHERE id = #{id};"
    return unless row

    promise = columns.zip(row).to_h
    wrap_promise(promise)
  end

  def find_by_user(user_id)
    result = DB.execute2 "SELECT * FROM promises WHERE user_id = '#{user_id}';"
    column_names = result.first
    columns = result[1..-1]

    promises = columns.collect { |x| wrap_promise(column_names.zip(x).to_h) }
  end

  def get_stats_for_user(user_id)
    result = DB.execute2 <<-SQL
      SELECT status, COUNT(*)
      FROM promises
      WHERE user_id='#{user_id}'
      GROUP BY status;
    SQL
    Hash[result.drop 1]
  end

  def update(promise)
    DB.execute <<-SQL
      UPDATE promises
      SET
        status = '#{promise.status}',
        title = '#{promise.title}',
        body = '#{promise.body}',
        privacy = '#{promise.privacy}',
        completed_reference = '#{promise.completed_reference}'
      WHERE id = #{promise.id};
    SQL
  end

  def delete(id)
    DB.execute "DELETE FROM promise WHERE id = #{id};"
  end

  def wrap_promise(promise)
    Promise.new(
        promise['status'],
        promise['title'],
        promise['body'],
        promise['completed_reference'],
        promise['user_id'],
        promise['privacy'],
        promise['id']
      )
  end
end
