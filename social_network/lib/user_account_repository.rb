require 'user_account'
class UserAccountRepository

    # Selecting all records
    # No arguments
    def all
      # Executes the SQL query:
        sql = 'SELECT id, username, email_address FROM user_accounts;'
    
        result_set = DatabaseConnection.exec_params(sql, [])

        user_accounts = []

        result_set.each do |record|
            user_accounts << record_to_user_account_object(record)

      end

      # Returns an array of UserAccount objects.
      return user_accounts
    end
  
    # Gets a single record by its ID
    # One argument: the id (number)
    def find(id)
      # Executes the SQL query:
        sql = 'SELECT id, username, email_address FROM user_accounts WHERE id = $1;'
        sql_params = [id]
        result = DatabaseConnection.exec_params(sql, sql_params)
      # Returns a single UserAccount object.

        record = result[0]
        return record_to_user_account_object(record)

    end
  
    # Add more methods below for each operation you'd like to implement.
  
    def create(user_account)
      # Executes the SQL query
      sql = 'INSERT INTO user_accounts (username, email_address) VALUES ($1, $2);'
      sql_params = [user_account.username, user_account.email_address]
      DatabaseConnection.exec_params(sql, sql_params)
      # No return
    end
  
    def delete(id)
      # Executes the SQL query
      sql = 'DELETE FROM user_accounts WHERE id = $1;'
      sql_params = [id]
      DatabaseConnection.exec_params(sql, sql_params)
      # No return 
    end


    private 

    def record_to_user_account_object(record)
        user_account = UserAccount.new
        user_account.id = record['id']
        user_account.username = record['username']
        user_account.email_address = record['email_address']

        return user_account
    end
  end