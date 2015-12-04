require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Sanji
  class AppGenerator < Rails::Generators::AppGenerator

    def finish_template
      invoke :sanji_initial_tasks
      super
    end

    def run_after_bundle_callbacks
      invoke :sanji_after_bundle_tasks
      super
    end

    def sanji_initial_tasks
      puts 'Starting Sanji customization'
      build :initial_tasks
    end

    def sanji_after_bundle_tasks
      puts 'Running Sanji after_bundle tasks'
      build :after_bundle_tasks
    end



    protected

    def get_builder_class
      Sanji::AppBuilder
    end

  end
end
