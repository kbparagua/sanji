module Sanji
  class AppBuilder < Rails::AppBuilder

    RECIPES = [
      :Annotate
    ]


    def after_create_tasks
      puts 'Sanji: Doing initial tasks...'

      RECIPES.each do |name|
        self.get_recipe_instance(name).after_create
      end
    end

    def after_bundle_tasks
      puts 'Sanji: Doing after bundle tasks...'

      RECIPES.each do |name|
        self.get_recipe_instance(name).after_bundle
      end
    end

    def after_everything_tasks
      puts 'Sanji: Doing after everything tasks...'

      RECIPES.each do |name|
        self.get_recipe_instance(name).after_everything
      end
    end



    protected

    def get_recipe_instance name
      recipe_class = ::Sanji::Recipes.const_get name
      recipe_class.new self
    end

  end
end
