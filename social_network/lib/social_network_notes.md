# {{TABLE NAME}} Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `students`*

```
# EXAMPLE

Table: students

Columns:
id | name | cohort_name
```

# Two Tables Design Recipe Template

_Copy this recipe template to design and create two related database tables from a specification._

## 1. Extract nouns from the user stories or specification

```
# EXAMPLE USER STORY:
# (analyse only the relevant part - here the final line).

As a social network user,
So I can have my information registered,
I'd like to have a user account with my email address.

As a social network user,
So I can have my information registered,
I'd like to have a user account with my username.

As a social network user,
So I can write on my timeline,
I'd like to create posts associated with my user account.

As a social network user,
So I can write on my timeline,
I'd like each of my posts to have a title and a content.

As a social network user,
So I can know who reads my posts,
I'd like each of my posts to have a number of views.
```

```
Nouns:

user_account, email_address, username, 
posts, title, content, views_number
```

## 2. Infer the Table Name and Columns

Put the different nouns in this table. Replace the example with your own nouns.

| Record                | Properties          |
| --------------------- | ------------------  |
| user_account          | username, email_address
| posts                 | title, content, views

1. Name of the first table (always plural): `user_accounts` 

    Column names: `username`, `email_address`

2. Name of the second table (always plural): `posts` 

    Column names: `title`, `content`, `views`

## 3. Decide the column types.

[Here's a full documentation of PostgreSQL data types](https://www.postgresql.org/docs/current/datatype.html).

Most of the time, you'll need either `text`, `int`, `bigint`, `numeric`, or `boolean`. If you're in doubt, do some research or ask your peers.

Remember to **always** have the primary key `id` as a first column. Its type will always be `SERIAL`.

```
# EXAMPLE:

Table: user_accounts
id: SERIAL
username: text
email_address: text

Table: posts
id: SERIAL
title: text
content: text
views = int
```

## 4. Decide on The Tables Relationship

Most of the time, you'll be using a **one-to-many** relationship, and will need a **foreign key** on one of the two tables.

To decide on which one, answer these two questions:

1. Can one [TABLE ONE] have many [TABLE TWO]? (Yes/No)
2. Can one [TABLE TWO] have many [TABLE ONE]? (Yes/No)

You'll then be able to say that:

1. **[A] has many [B]**
2. And on the other side, **[B] belongs to [A]**
3. In that case, the foreign key is in the table [B]

Replace the relevant bits in this example with your own:

```
# EXAMPLE

1. Can one user_account have many posts? YES
2. Can one post have many user_accounts? NO

-> Therefore,
-> A user_account HAS MANY posts
-> A post BELONGS TO a user_account

-> Therefore, the foreign key is on the posts table.
```

*If you can answer YES to the two questions, you'll probably have to implement a Many-to-Many relationship, which is more complex and needs a third table (called a join table).*

## 4. Write the SQL.

```sql
-- EXAMPLE
-- file: albums_table.sql

-- Replace the table name, columm names and types.

-- Create the table without the foreign key first.
CREATE TABLE user_accounts (
  id SERIAL PRIMARY KEY,
  username text,
  email_address text
);

-- Then the table with the foreign key first.
CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  title text,
  content text,
  views int,
-- The foreign key name is always {other_table_singular}_id
  user_account_id int,
  constraint fk_user_account foreign key(user_account_id)
    references user_accounts(id)
    on delete cascade
);

```

## 5. Create the tables.

```bash
psql -h 127.0.0.1 database_name < user_accounts_table.sql
```

<!-- BEGIN GENERATED SECTION DO NOT EDIT -->

---


<!-- END GENERATED SECTION DO NOT EDIT -->















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

TRUNCATE TABLE user_accounts RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO user_accounts (username, email_address) VALUES ('molly_gal', 'molly@example.com');
INSERT INTO user_accounts (username, email_address) VALUES ('mo_gal_wick', 'mo@example.com');
INSERT INTO user_accounts (username, email_address) VALUES ('gal_wick', 'galwick@example.com');
INSERT INTO user_accounts (username, email_address) VALUES ('wickgal', 'wickgal@example.com');
INSERT INTO user_accounts (username, email_address) VALUES ('mogal', 'mogal@example.com');


TRUNCATE TABLE posts RESTART IDENTITY;
INSERT INTO posts (title, content, views, user_account_id) VALUES ('My Post title 1', 'My content 1', 5432, 1);
INSERT INTO posts (title, content, views, user_account_id) VALUES ('My Post title 2', 'My content 2', 234, 1);
INSERT INTO posts (title, content, views, user_account_id) VALUES ('Other Post title 1', 'Other content 1', 4, 2);
INSERT INTO posts (title, content, views, user_account_id) VALUES ('Other Post title 2', 'Other content 2', 4321, 2);
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < seeds_{table_name}.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: students

# Model class
# (in lib/student.rb)
class UserAccount
end

# Repository class
# (in lib/student_repository.rb)
class UserAccountRepository
end


class Post
end

class PostRepository
end

```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: students

# Model class
# (in lib/student.rb)

class UserAccount

  # Replace the attributes by your own columns.
  attr_accessor :id, :username, :email_address
end

class Post
    attr_accessor :id, :title, :content, :views, :user_account_id
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# student = Student.new
# student.name = 'Jo'
# student.name
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: students

# Repository class
# (in lib/student_repository.rb)

class UserAccountRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, username, email_address FROM user_accounts;

    # Returns an array of UserAccount objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, username, email_address FROM user_accounts WHERE id = $1;
    # sql_params = [id]

    # Returns a single UserAccount object.
  end

  # Add more methods below for each operation you'd like to implement.

  def create(user_account)
    # Executes the SQL query
    # sql = 'INSERT INTO user_accounts (username, email_address) VALUES ($1, $2);'
    # sql_params = [user_account.username, user_account.email_address]
    # No return
  end

  def delete(id)
    # Executes the SQL query
    # sql = 'DELETE FROM user_accounts WHERE id = $1;'
    # sql_params = [id]
    # No return 
  end
end



class PostRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, title, content, views, user_account_id FROM posts;

    # Returns an array of Post objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, title, content, views, user_account_id FROM posts WHERE id = $1;
    # sql_params = [id]

    # Returns a single Post object.
  end

  def create(user_account)
    # Executes the SQL query
    # sql = 'INSERT INTO posts (title, content, views, user_account_id) VALUES ($1, $2, $3, $4);'
    # sql_params = [post.title, post.content, post.views, post.user_account_id]
    # No return
  end

  def delete(id)
    # Executes the SQL query
    # sql = 'DELETE FROM posts WHERE id = $1;'
    # sql_params = [id]
    # No return 
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

### USER ACCOUNTS
# 1
# Get all user_accounts

repo = UserAccountRepository.new

user_accounts = repo.all

expect(user_accounts.length).to eq 5

expect(user_accounts[0].id).to eq '1'
expect(user_accounts[0].username).to eq 'molly_gal'
expect(user_accounts[0].email_address).to eq 'molly@example.com'

expect(user_accounts[1].id).to eq '2'
expect(user_accounts[1].username).to eq 'mo_gal_wick'
expect(user_accounts[1].email_address).to eq 'mo@example.com'

# 2
# Get a single user_account

repo = UserAccountRepository.new

user_account = repo.find(1)

expect(user_account.id).to eq '1'
expect(user_account.username).to eq 'molly_gal'
expect(user_account.email_address).to eq 'molly@example.com'

# 3
# Create new user_account
repo = UserAccountRepository.new
new_user_account = UserAccount.new
new_user_account.username = 'rehgallag yllom'
new_user_account.email_address = 'rehgallag@example.com'
repo.create(new_user_account)
expect(repo.all).to include (
  have_attributes (
    username: 'rehgallag yllom'
    )
)
 # => new_user_account

# 4
# Delete a user_account (with no related records)
repo = UserAccountRepository.new
user_account = repo.delete(5)
all_user_accounts = repo.all
expect(all_user_accounts).not_to include (
  have_attributes (
    id: '5'
  )
)

#not include id 5


### POSTS

# 1
# Get all posts

repo = PostRepository.new

posts = repo.all

expect(posts.length).to eq 4

expect(posts[0].id).to eq '1'
expect(posts[0].title).to eq 'My Post title 1'
expect(posts[0].content).to eq 'My content 1'
expect(posts[0].views).to eq '5432'
expect(posts[0].user_account_id).to eq '1'

expect(posts[1].id).to eq '2'
expect(posts[1].title).to eq 'My Post title 2'
expect(posts[1].content).to eq 'My content 2'
expect(posts[1].views).to eq '234'
expect(posts[1].user_account_id).to eq '1'


# 2
# Get a single post

repo = PostRepository.new

post = repo.find(1)

expect(post.id).to eq 1
expect(post.title).to eq 'My Post title 1'
expect(post.content).to eq  'My content 1'
expect(post.views).to eq '5432'
expect(post.user_account_id).to eq '1'

# 3
# Create new post
repo = PostRepository.new
new_post = Post.new
new_post.title = 'Another post title 1'
new_post.content = 'Another content 1'
new_post.views = '467'
new_post.user_account_id = '3'
repo.create(new_post)
expect(repo.all).to include (
  have_attributes (
    title = 'Another post title 1'
  )
) # => new_post

# 4
# Delete a post 
repo = PostRepository.new
post = repo.delete(4)
all_posts = repo.all
expect(all_posts).not_to include (
  have_attributes (
    id: '4'
  ) #not include id 4
)


# 
# Delete a user_account (with a related record - posts)
repo = UserAccountRepository.new
user_account = repo.delete(2)
all_user_accounts = repo.all
expect(all_user_accounts).not_to include(
  have_attributes (
    id: '2'
  )
) #not include id 2
repo2 = PostRepository.new
all_posts = repo2.all
expect(all_posts).not_to include (
  have_attributes (
    user_account_id: '2'
  )
) # not include user_account_id 2


# Add more examples for each method
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/student_repository_spec.rb

def reset_students_table
  seed_sql = File.read('spec/seeds_students.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'students' })
  connection.exec(seed_sql)
end

describe StudentRepository do
  before(:each) do 
    reset_students_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

<!-- BEGIN GENERATED SECTION DO NOT EDIT -->

---

**How was this resource?**  
[😫](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😫) [😕](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😕) [😐](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😐) [🙂](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=🙂) [😀](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😀)  
Click an emoji to tell us.

<!-- END GENERATED SECTION DO NOT EDIT -->
