TRUNCATE TABLE posts RESTART IDENTITY;

INSERT INTO posts (title, content, views, user_account_id) VALUES ('My Post title 1', 'My content 1', 5432, 1);
INSERT INTO posts (title, content, views, user_account_id) VALUES ('My Post title 2', 'My content 2', 234, 1);
INSERT INTO posts (title, content, views, user_account_id) VALUES ('Other Post title 1', 'Other content 1', 4, 2);
INSERT INTO posts (title, content, views, user_account_id) VALUES ('Other Post title 2', 'Other content 2', 4321, 2);