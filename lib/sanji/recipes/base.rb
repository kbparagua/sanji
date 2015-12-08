module Sanji
  module Recipes
    class Base

      attr_reader :builder

      def initialize builder = nil
        @builder = builder
      end

      def run_after_create
        self.log_start :after_create
        self.after_create
        self.log_end :after_create
      end

      def run_after_bundle
        self.log_start :after_bundle
        self.after_bundle
        self.log_end :after_bundle
      end

      def run_after_everything
        self.log_start :after_everything
        self.after_everything
        self.log_end :after_everything
      end

      def after_create
      end

      def after_bundle
      end

      def after_everything
      end


      protected

      def log_start method_name
        self.say "start ##{method_name}"
      end

      def log_end method_name
        self.say "end ##{method_name}"
      end

      def say text
        complete_text = "#{self.class.name} -> #{text}"
        self.builder.say complete_text, Thor::Shell::Color::YELLOW
      end

    end
  end
end
