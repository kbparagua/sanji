module Sanji
  module Config; end
  module Recipes; end
end

require 'sanji/config'
require 'sanji/assistant'
require 'sanji/app_generator'
require 'sanji/app_builder'
require 'sanji/recipe'
require 'sanji/recipes'

$cookbook = ::Sanji::Config::Main.instance.preferred_cookbook
