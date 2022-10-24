# {{TABLE NAME}} Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `recipes`*

```
# EXAMPLE
Table: recipes
Columns:
id | name | cohort_name
```
# Single Table Design Recipe Template

_Copy this recipe template to design and create a database table from a specification._

## 1. Extract nouns from the user stories or specification

```
As a food lover,
So I can stay organised and decide what to cook,
I'd like to keep a list of all my recipes with their names.

As a food lover,
So I can stay organised and decide what to cook,
I'd like to keep the average cooking time (in minutes) for each recipe.

As a food lover,
So I can stay organised and decide what to cook,
I'd like to give a rating to each of the recipes (from 1 to 5).
```

```
Nouns:
recipe, name, cooking time, rating
```

## 2. Infer the Table Name and Columns

Put the different nouns in this table. Replace the example with your own nouns.

| Record                | Properties          |
| --------------------- | ------------------  |
| recipe                | name, cooking_time, rating

Name of the table (always plural): `recipes` 

Column names: `name`, `cooking_time`, `rating`

## 3. Decide the column types.

[Here's a full documentation of PostgreSQL data types](https://www.postgresql.org/docs/current/datatype.html).

Most of the time, you'll need either `text`, `int`, `bigint`, `numeric`, or `boolean`. If you're in doubt, do some research or ask your peers.

Remember to **always** have the primary key `id` as a first column. Its type will always be `SERIAL`.

```
# EXAMPLE:
id: SERIAL
name: text
cooking_time: int
rating: int
```

## 4. Write the SQL.

```sql
-- EXAMPLE
-- file: albums_table.sql
-- Replace the table name, columm names and types.
CREATE TABLE recipes (
  id SERIAL PRIMARY KEY,
  name text,
  cooking_time int,
  rating int
);
```

## 5. Create the table.

```bash
psql -h 127.0.0.1 recipes_directory < recipes_table.sql
```

<!-- BEGIN GENERATED SECTION DO NOT EDIT -->

---












## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_{table_name}.sql)
-- Write your SQL seed here. 
-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)
TRUNCATE TABLE recipes RESTART IDENTITY; -- replace with your own table name.
-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.
INSERT INTO recipes (id, name, cooking_time, rating) VALUES (5, 'Cottage Pie', 75, 1);

INSERT INTO recipes (id, name, cooking_time, rating) VALUES (1, 'Pesto Pasta', 15, 5);

INSERT INTO recipes (id, name, cooking_time, rating) VALUES (2, 'Fish Pie', 60, 4);

INSERT INTO recipes (id, name, cooking_time, rating) VALUES (3, 'Jacket Potato with cheese and beans', 30, 3);

INSERT INTO recipes (id, name, cooking_time, rating) VALUES (4, 'Sag Paneer', 30, 5);

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < seeds_{table_name}.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: recipes
# Model class
# (in lib/recipe.rb)
class Recipe
end
# Repository class
# (in lib/recipe_repository.rb)
class RecipeRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: recipes
# Model class
# (in lib/recipe.rb)
class Recipe
  # Replace the attributes by your own columns.
  attr_accessor :id, :name, :cooking_time, :rating
end
# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# recipe = recipe.new
# recipe.name = 'Jo'
# recipe.name
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: recipes
# Repository class
# (in lib/recipe_repository.rb)
class RecipeRepository
  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, name, cooking_time, rating FROM recipes;
    # Returns an array of Recipe objects.
  end
  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, name, cooking_time, rating FROM recipes WHERE id = $1;
    # sql_params = [id]
    # Returns a single Recipe object.
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES
# 1
# Get all recipes
repo = RecipeRepository.new
recipes = repo.all
expect(recipes.length).to eq 5
expect(recipes[0].id).to eq 1
expect(recipes[0].name).to eq 'Pesto Pasta'
expect(recipes[0].cooking_time).to eq 15
expect(recipes[0].rating).to eq 5
expect(recipes[1].id).to eq 2
expect(recipes[1].name).to eq 'Fish Pie'
expect(recipes[1].cooking_time).to eq 60
expect(recipes[1].rating).to eq 4

# 2
# Get a single recipe
repo = RecipeRepository.new
recipe = repo.find(4)
expect(recipe.id).to eq '4'
expect(recipe.name).to eq 'Sag Paneer'
expect(recipe.cooking_time).to eq '30'
expect(recipe.rating).to eq '5'

```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE
# file: spec/recipe_repository_spec.rb
def reset_recipes_table
  seed_sql = File.read('spec/seeds_recipes.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'recipes_directory_test' })
  connection.exec(seed_sql)
end
describe RecipeRepository do
  before(:each) do 
    reset_recipes_table
  end
  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

<!-- BEGIN GENERATED SECTION DO NOT EDIT -->

---



