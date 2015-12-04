module Sanji
end

require 'sanji/recipes/base'

Dir["#{File.dirname(__FILE__)}/sanji/recipes/*.rb"].each do |filename|
  next if filename.index 'base.rb'

  require filename.sub('.rb', '')
end

require 'sanji/app_generator'
require 'sanji/app_builder'

