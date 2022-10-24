# file: app.rb

require_relative 'lib/database_connection'
require_relative 'lib/recipe_repository'

# We need to give the database name to the method `connect`.
DatabaseConnection.connect('recipes_directory')

# Perform a SQL query on the database and get the result set.
sql = 'SELECT name FROM recipes;'
result = DatabaseConnection.exec_params(sql, [])

# Print out each record from the result set .
result.each do |record|
  p "#{record['name']}"
end