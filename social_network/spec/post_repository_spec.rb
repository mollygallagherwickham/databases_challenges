require 'post_repository'
require 'post'

RSpec.describe PostRepository do
    def reset_posts_table
        seed_sql = File.read('spec/seeds_posts.sql')
        connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
        connection.exec(seed_sql)
    end
      
      describe PostRepository do
        before(:each) do 
          reset_posts_table
        end

        it "gets all posts" do
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
        end

        it "gets a single post" do
            repo = PostRepository.new

            post = repo.find(1)

            expect(post.id).to eq '1'
            expect(post.title).to eq 'My Post title 1'
            expect(post.content).to eq  'My content 1'
            expect(post.views).to eq '5432'
            expect(post.user_account_id).to eq '1'
        end

        it "creates new post" do
            repo = PostRepository.new
            new_post = Post.new
            new_post.title = 'Another post title 1'
            new_post.content = 'Another content 1'
            new_post.views = '467'
            new_post.user_account_id = '3'
            repo.create(new_post)
            expect(repo.all).to include(
                have_attributes(
                    title: 'Another post title 1',
                    content: new_post.content
                )
            )
        end

        it "deletes a post" do
            repo = PostRepository.new
            post = repo.delete(4)
            all_posts = repo.all
            expect(all_posts).not_to include(
                have_attributes(
                    id: '4'
                )
            )
        end
    end
end