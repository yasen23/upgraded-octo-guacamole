module CommentRepository
  extend self

  def create(comment)
    DB.execute <<-SQL
      INSERT INTO comments (
        `text`, `user_id`, `promise_id`, `score`
      ) VALUES (
        '#{comment.text}', '#{comment.user_id}', '#{comment.promise_id}', '#{comment.score}'
      );
    SQL
  end

  def get_by_promise_id(promise_id)
    result = DB.execute <<-SQL
      SELECT *
      FROM comments
      WHERE promise_id = '#{promise_id}'
      JOIN (
        SELECT username, id
        FROM users) k
      ON k.id == user_id;
    SQL
    print result
    column_names = result.first
    columns = result[1..-1]

    comments = columns.collect { |x| wrap_comment(column_names.zip(x).to_h) }
  end

  def delete(id)
    DB.execute "DELETE FROM comments WHERE id = #{id};"
  end

  def wrap_promise(comment)
    Comment.new(
        comment['id'],
        comment['timestamp'],
        comment['username'],
        comment['text'],
        comment['user_id'],
        comment['promise_id'],
        comment['score']
      )
  end
end
