module Sanji
  module Config
  end

  module Recipes
  end

  module Locals
  end

  module Utilities
  end
end

# Require config files.
Dir["#{File.dirname(__FILE__)}/sanji/config/*.rb"].each do |filename|
  require filename.sub(/\.rb\z/, '')
end

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
if Sanji::Config::Main.instance.user_recipes_path.present?
  Dir["#{Sanji::Config::Main.instance.user_recipes_path}/*.rb"].each do |filename|
    require filename.sub(/\.rb\z/, '')
  end
end



