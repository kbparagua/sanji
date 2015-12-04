module Sanji
  module Recipes
    class Base

      attr_reader :builder

      def initialize builder = nil
        @builder = builder
      end

    end
  end
end
