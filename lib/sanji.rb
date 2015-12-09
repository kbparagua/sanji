module Sanji
  module Recipes
  end

  module Locals
  end

  module Utilities
  end
end

require 'sanji/config'
require 'sanji/options'

# Require all utilities
Dir["#{File.dirname(__FILE__)}/sanji/utilities/*.rb"].each do |filename|
  require filename.sub(/\.rb\z/, '')
end

require 'sanji/assistant'
require 'sanji/recipe'
require 'sanji/app_generator'
require 'sanji/app_builder'

# Require all recipes
Dir["#{File.dirname(__FILE__)}/sanji/recipes/*.rb"].each do |filename|
  require filename.sub(/\.rb\z/, '')
end

# Require user recipes
if Sanji::Options.instance.user_recipes_path
  Dir["#{Sanji::Options.instance.user_recipes_path}/*.rb"].each do |filename|
    require filename.sub(/\.rb\z/, '')
  end
end



