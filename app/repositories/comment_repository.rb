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
    columns = DB.execute <<-SQL
      SELECT l.id, timestamp, k.username, text, user_id, promise_id, score
      FROM comments l
      JOIN (
        SELECT id, username
        FROM users) k
      ON k.id == user_id;
      WHERE promise_id = '#{promise_id}'
    SQL

    column_names = ['id', 'timestamp', 'username', 'text', 'user_id', 'promise_id', 'score']
    columns.collect { |x| wrap_comment(column_names.zip(x).to_h) }
  end

  def delete(id)
    DB.execute "DELETE FROM comments WHERE id = #{id};"
  end

  def wrap_comment(comment)
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
