module Sanji
  class AppBuilder < Rails::AppBuilder

    RECIPES = [
      :Annotate
    ]


    def initial_tasks
      puts 'Sanji: Doing initial tasks...'

      RECIPES.each do |name|
        recipe_class = ::Sanji::Recipes.const_get name
        recipe_class.new(self).start
      end
    end


    def after_bundle_tasks
      puts 'Sanji: Doing after bundle tasks...'
    end

  end
end
