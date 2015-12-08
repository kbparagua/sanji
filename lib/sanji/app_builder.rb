module Sanji
  class AppBuilder < Rails::AppBuilder

    RECIPES = [
      :Setup,
      :Annotate,
      :Draper,
      :Figaro,
      :Haml,
      :Paloma,
      :Postgresql,
      :Reform,
      :Seedbank,
      :Cleanup
    ]

    def after_create_tasks
      RECIPES.each do |name|
        self.get_recipe_instance(name).run_after_create
      end
    end

    def after_bundle_tasks
      RECIPES.each do |name|
        self.get_recipe_instance(name).run_after_bundle
      end
    end

    def after_everything_tasks
      RECIPES.each do |name|
        self.get_recipe_instance(name).run_after_everything
      end
    end



    protected

    def get_recipe_instance name
      recipe = self.recipe_instances[name]
      return recipe if recipe

      recipe_class = ::Sanji::Recipes.const_get name
      recipe = recipe_class.new self

      self.recipe_instances[name] = recipe
      recipe
    end

    def recipe_instances
      @recipe_instances ||= {}
    end

  end
end
