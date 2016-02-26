module Sanji::Config
  class CookbookBuilder

    def self.instance config_file = nil
      return @instance unless config_file
      @instance = self.new config_file
    end


    def initialize config
      @config = config
    end

    def build name = ''
      entry = @config.cookbook_entry name
      Cookbook.new name, entry
    end

  end
end
