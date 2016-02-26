module Sanji
  module Config; end
  module Recipes; end
  module Locals; end
  module Utilities; end
end

# Require all utilities
Dir["#{File.dirname(__FILE__)}/sanji/utilities/*.rb"].each do |filename|
  require filename.sub(/\.rb\z/, '')
end

require 'sanji/config'
require 'sanji/assistant'
require 'sanji/app_generator'
require 'sanji/app_builder'
require 'sanji/recipe'
require 'sanji/recipes'



