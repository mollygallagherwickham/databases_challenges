require_relative 'lib/book_repository'
require_relative 'lib/database_connection'

# We need to give the database name to the method `connect`.
DatabaseConnection.connect('book_store')

# Perform a SQL query on the database and get the result set.
sql = 'SELECT id, title, author_name FROM books;'
result = DatabaseConnection.exec_params(sql, [])


# Print out each record from the result set .
result.each do |record|
    p "#{record['id']} - #{record['title']} - #{record['author_name']}"
end