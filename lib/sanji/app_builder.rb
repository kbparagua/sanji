module Sanji
  class AppBuilder < Rails::AppBuilder

    def after_create_tasks
      self.recipe_classes.each do |recipe_class|
        self.get_recipe_instance(recipe_class).run_after_create
      end
    end

    def after_bundle_tasks
      self.recipe_classes.each do |recipe_class|
        self.get_recipe_instance(recipe_class).run_after_bundle
      end
    end

    def after_everything_tasks
      self.recipe_classes.each do |recipe_class|
        self.get_recipe_instance(recipe_class).run_after_everything
      end
    end



    protected

    def recipe_classes
      Options.instance.recipe_classes
    end

    def get_recipe_instance recipe_class
      recipe = self.recipe_instances[recipe_class.name.to_sym]
      return recipe if recipe

      recipe = recipe_class.new self

      self.recipe_instances[recipe_class.name.to_sym] = recipe
      recipe
    end

    def recipe_instances
      @recipe_instances ||= {}
    end

  end
end
