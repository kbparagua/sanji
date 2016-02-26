module Sanji
  class AppBuilder < Rails::AppBuilder

    def initialize app_base
      super app_base
      Assistant.initialize_instance self
    end

    def after_create_tasks
      Recipes::Setup.instance.run_after_create

      self.recipe_classes.each do |recipe_class|
        recipe_class.instance.run_after_create
      end

      Recipes::Cleanup.instance.run_after_create
    end

    def after_bundle_tasks
      Recipes::Setup.instance.run_after_bundle

      self.recipe_classes.each do |recipe_class|
        recipe_class.instance.run_after_bundle
      end

      Recipes::Cleanup.instance.run_after_bundle
    end

    def after_everything_tasks
      Recipes::Setup.instance.run_after_everything

      self.recipe_classes.each do |recipe_class|
        recipe_class.instance.run_after_everything
      end

      Recipes::Cleanup.instance.run_after_everything
    end



    protected

    def recipe_classes
      Config::Main.instance.recipe_classes
    end

  end
end
