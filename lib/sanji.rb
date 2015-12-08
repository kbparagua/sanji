module Sanji
  module Recipes
  end

  module Utilities
  end
end

# Require all utilities
Dir["#{File.dirname(__FILE__)}/sanji/utilities/*.rb"].each do |filename|
  require filename.sub('.rb', '')
end


require 'sanji/assistant'
require 'sanji/recipe'

# Require all recipes
Dir["#{File.dirname(__FILE__)}/sanji/recipes/*.rb"].each do |filename|
  require filename.sub('.rb', '')
end

require 'sanji/app_generator'
require 'sanji/app_builder'

