module Sanji
  module Recipes
  end
end

require 'sanji/recipe'

# Require all recipes
Dir["#{File.dirname(__FILE__)}/sanji/recipes/*.rb"].each do |filename|
  require filename.sub('.rb', '')
end

require 'sanji/app_generator'
require 'sanji/app_builder'

