require 'recipe_repository'

RSpec.describe RecipeRepository do
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
        it "gets all recipes" do
            repo = RecipeRepository.new
            recipes = repo.all
            expect(recipes.length).to eq 5
            expect(recipes[0].id).to eq '1'
            expect(recipes[0].name).to eq 'Pesto Pasta'
            expect(recipes[0].cooking_time).to eq '15'
            expect(recipes[0].rating).to eq '5'
            expect(recipes[1].id).to eq '2'
            expect(recipes[1].name).to eq 'Fish Pie'
            expect(recipes[1].cooking_time).to eq '60'
            expect(recipes[1].rating).to eq '4'
        end

        it "gets a single recipe" do
            repo = RecipeRepository.new
            recipe = repo.find(4)
            expect(recipe.id).to eq '4'
            expect(recipe.name).to eq 'Sag Paneer'
            expect(recipe.cooking_time).to eq '30'
            expect(recipe.rating).to eq '5'
        end
      end
end