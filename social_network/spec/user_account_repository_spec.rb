require 'user_account_repository'
require 'user_account'

RSpec.describe UserAccountRepository do
    def reset_user_accounts_table
        seed_sql = File.read('spec/seeds_user_accounts.sql')
        connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
        connection.exec(seed_sql)
      end
      
      describe UserAccountRepository do
        before(:each) do 
          reset_user_accounts_table
        end
      
        it 'gets all user accounts' do
            repo = UserAccountRepository.new
    
            user_accounts = repo.all
    
            expect(user_accounts.length).to eq 5
    
            expect(user_accounts[0].id).to eq '1'
            expect(user_accounts[0].username).to eq 'molly_gal'
            expect(user_accounts[0].email_address).to eq 'molly@example.com'
    
            expect(user_accounts[1].id).to eq '2'
            expect(user_accounts[1].username).to eq 'mo_gal_wick'
            expect(user_accounts[1].email_address).to eq 'mo@example.com'
    
        end

        it "gets a single user_account" do
            repo = UserAccountRepository.new

            user_account = repo.find(1)

            expect(user_account.id).to eq '1'
            expect(user_account.username).to eq 'molly_gal'
            expect(user_account.email_address).to eq 'molly@example.com'

        end

        it "creates new user account" do
            repo = UserAccountRepository.new
            new_user_account = UserAccount.new
            
            new_user_account.username = 'rehgallag yllom'
            new_user_account.email_address = 'rehgallag@example.com'
            repo.create(new_user_account)
            all_user_accounts = repo.all
            expect(all_user_accounts).to include(
                have_attributes(
                    username: 'rehgallag yllom'
                )
            )
        end

        it "deletes user account with no related records" do
            repo = UserAccountRepository.new
            user_account = repo.delete(5)
            all_user_accounts = repo.all
            expect(all_user_accounts).not_to include(
                have_attributes(
                id: '5'
                )
            )
        end

        it "deletes user account with a related" do
            repo = UserAccountRepository.new
            user_account = repo.delete(1)
            all_user_accounts = repo.all
            expect(all_user_accounts).not_to include(
                have_attributes(
                id: '1'
                )
            )
        end
      end
    
end