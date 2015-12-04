module Sanji
  module Recipes
    class Base

      attr_reader :builder

      def initialize builder = nil
        @builder = builder
      end

      def run_after_create
        self.say 'running #after_create'
        self.after_create
        self.say 'finished #after_create'
      end

      def run_after_bundle
        self.say 'running #after_bundle'
        self.after_bundle
        self.say 'finished #after_bundle'
      end

      def run_after_everything
        self.say 'running #after_everything'
        self.after_everything
        self.say 'finished #after_everything'
      end

      def after_create
      end

      def after_bundle
      end

      def after_everything
      end


      protected

      def say text
        complete_text = "#{self.class.name} -> #{text}"
        self.builder.say complete_text, Thor::Shell::Color::YELLOW
      end
    end
  end
end
