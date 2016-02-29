module Sanji
  class AppBuilder < Rails::AppBuilder

    def initialize app_base
      super app_base
      Assistant.initialize_instance self
    end

    def after_create_tasks
      self.recipe_classes.each do |recipe_class|
        recipe_class.instance.run_after_create
      end
    end

    def after_bundle_tasks
      self.recipe_classes.each do |recipe_class|
        recipe_class.instance.run_after_bundle
      end
    end

    def after_everything_tasks
      self.recipe_classes.each do |recipe_class|
        recipe_class.instance.run_after_everything
      end
    end



    protected

    def recipe_classes
      $cookbook.recipes.map &:class_instance
    end

  end
end
