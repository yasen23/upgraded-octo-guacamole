module CommentRepository
  extend self

  def create(comment)
    statement = DB.prepare <<-SQL
      INSERT INTO comments (
        `text`, `user_id`, `promise_id`, `score`
      ) VALUES (
        ?, ?, ?, ?
      );
    SQL
    statement.execute(comment.text, comment.user_id, comment.promise_id, comment.score)
  end

  def get_by_promise_id(promise_id)
    statement = DB.prepare <<-SQL
      SELECT l.id, timestamp, k.username, text, user_id, promise_id, score
      FROM comments l
      JOIN (
        SELECT id, username
        FROM users) k
      ON k.id == user_id
      WHERE promise_id = ?;
    SQL

    columns = statement.execute(promise_id)
    print 'Promise ID'
    print promise_id
    column_names = ['id', 'timestamp', 'username', 'text', 'user_id', 'promise_id', 'score']
    columns.collect { |x| wrap_comment(column_names.zip(x).to_h) }
  end

  def delete(id)
    statement = DB.prepare "DELETE FROM comments WHERE id = ?;"
    statement.execute(id)
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
