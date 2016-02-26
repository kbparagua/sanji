module Sanji::Config
  class Sanji::Config::CookbookBuilder

    def initialize config
      @config = config
    end

    def build name = ''
      entry = @config.cookbook_entry name
      cookbook = Cookbook.new name, entry

      included_cookbooks = entry['include'] || []
      self.include_cookbooks cookbook, included_cookbooks

      cookbook
    end


    protected

    def include_cookbooks target, cookbooks = []
      cookbooks.each do |cookbook_name|
        cookbook = self.class.new(@config).build cookbook_name
        target.include_cookbook cookbook
      end
    end

  end
end
