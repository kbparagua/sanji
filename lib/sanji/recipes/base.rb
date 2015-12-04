module Sanji
  module Recipes
    class Base

      attr_reader :builder

      def initialize builder = nil
        @builder = builder
      end

      def after_create
      end

      def after_bundle
      end

      def after_everything
      end

    end
  end
end
