require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Sanji
  class AppGenerator < Rails::Generators::AppGenerator

    def finish_template
      puts "source_paths = #{self.source_paths}"

      invoke :sanji_after_create_tasks
      super
    end

    def run_after_bundle_callbacks
      invoke :sanji_after_bundle_tasks
      super
      invoke :sanji_after_everything_tasks
    end

    def sanji_after_create_tasks
      build :after_create_tasks
    end

    def sanji_after_bundle_tasks
      build :after_bundle_tasks
    end

    def sanji_after_everything_tasks
      build :after_everything_tasks
    end



    protected

    def get_builder_class
      Sanji::AppBuilder
    end

  end
end
