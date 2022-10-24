require 'post'
class PostRepository

    # Selecting all records
    # No arguments
    def all
        sql = 'SELECT id, title, content, views, user_account_id FROM posts;'
        result_set = DatabaseConnection.exec_params(sql, [])
        posts = []

        result_set.each do |record|
            posts << record_to_post_object(record)
      end
      # Returns an array of Post objects.
      return posts
    end
  
    # Gets a single record by its ID
    # One argument: the id (number)
    def find(id)
        sql = 'SELECT id, title, content, views, user_account_id FROM posts WHERE id = $1;'
        sql_params = [id]
  
      # Returns a single Post object.

        result = DatabaseConnection.exec_params(sql, sql_params)
        record = result[0]
        return record_to_post_object(record)
    end
  
    def create(new_post)
      sql = 'INSERT INTO posts (title, content, views, user_account_id) VALUES ($1, $2, $3, $4);'
      sql_params = [new_post.title, new_post.content, new_post.views, new_post.user_account_id]
      DatabaseConnection.exec_params(sql, sql_params)
      return nil
    end
  
    def delete(id)
      sql = 'DELETE FROM posts WHERE id = $1;'
      sql_params = [id]
      DatabaseConnection.exec_params(sql, sql_params)
    end

    private

    def record_to_post_object(record)
        post = Post.new
        post.id = record['id']
        post.title = record['title']
        post.content = record['content']
        post.views = record['views']
        post.user_account_id = record['user_account_id']
        return post
    end
  end