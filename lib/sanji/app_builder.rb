module Sanji
  class AppBuilder < Rails::AppBuilder

    def after_create_tasks
      self.setup_recipe.run_after_create

      self.recipe_classes.each do |recipe_class|
        self.get_recipe_instance(recipe_class).run_after_create
      end

      self.cleanup_recipe.run_after_create
    end

    def after_bundle_tasks
      self.setup_recipe.run_after_bundle

      self.recipe_classes.each do |recipe_class|
        self.get_recipe_instance(recipe_class).run_after_bundle
      end

      self.cleanup_recipe.run_after_bundle
    end

    def after_everything_tasks
      self.setup_recipe.run_after_everything

      self.recipe_classes.each do |recipe_class|
        self.get_recipe_instance(recipe_class).run_after_everything
      end

      self.cleanup_recipe.run_after_everything
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

    def setup_recipe
      @setup_recipe ||= Sanji::Recipes::Setup.new(self)
    end

    def cleanup_recipe
      @cleanup_recipe ||= Sanji::Recipes::Cleanup.new(self)
    end

  end
end
