require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

require_relative "cookbook"
require_relative "scraping_service"

set :show, '/recipes/show'

get '/' do
  # '<h1>Hello <em>world</em>!</h1>'
  recipes_csv = File.join(__dir__, 'recipes.csv')
  cookbook = Cookbook.new(recipes_csv)
  @recipes = cookbook.all

  erb :index
end

get '/recipes/new' do
  erb :"recipes/new"
end

post '/recipes' do
  # binding.pry
  recipes_csv = File.join(__dir__, 'recipes.csv')
  cookbook = Cookbook.new(recipes_csv)

  new_recipe = Recipe.new(name: params[:name], description: params[:description], prep_time: params[:prep_time], difficulty: params[:difficulty])
  cookbook.add_recipe(new_recipe)
  redirect to '/'
end

get '/recipes/:index' do
  # binding.pry
  #@recipe = cookbook.find(params[:index])
  #DESTROY
  recipes_csv = File.join(__dir__, 'recipes.csv')
  cookbook = Cookbook.new(recipes_csv)
  if params[:status] == "ok"
    cookbook.remove_recipe(params[:index].to_i)
    redirect to '/'
  elsif params[:marker] == "not done"
    cookbook.mark_as_done(params[:index].to_i)
    redirect to '/'
  else
    @recipe = cookbook.find_recipe(params[:index].to_i)
  end

  erb :"recipes/show"
  # "The username is #{params[:username]}"
end

get '/result' do
  @results = ScrapingService.new(params[:ingredient]).call
  erb :result
end


private

def initialize_cookbook
  recipes_csv = File.join(__dir__, 'recipes.csv')
  return cookbook = Cookbook.new(recipes_csv)
end
