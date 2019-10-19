require_relative 'recipe'
require 'csv'

class Cookbook
  def initialize(csv)
    @recipes = []
    @csv = csv
    load
  end

  def all
    @recipes
  end

  def find_recipe(index)
    @recipes[index]
  end

  def add_recipe(recipe)
    @recipes << recipe
    save
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    save
  end

  def mark_as_done(recipe_index)
    recipe = @recipes[recipe_index]
    recipe.done!
    save
  end

  private

  def load
    csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
    CSV.foreach(@csv, csv_options) do |row|
      if row[2] == ""
        row[2] = "0"
      else
        row[2]
      end
      row[3] = row[3] == "true"
      @recipes << Recipe.new(name: row[0], description: row[1], prep_time: row[2], done: row[3], difficulty: row[4])
    end
  end

  def save
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"'}
    CSV.open(@csv, 'wb', csv_options) do |csv|
      csv << ["name", "description", "preparation time", "done", "difficulty"]
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.prep_time, recipe.done?, recipe.difficulty]
      end
    end
  end
end

# csv_file = File.join(__dir__, 'recipes.csv')
# recipe = Recipe.new("testing recipe", "too good")
# cookbook = Cookbook.new(csv_file)
# cookbook.add_recipe(recipe)
# p cookbook.find(2)
