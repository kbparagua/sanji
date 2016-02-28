module Sanji::Config
  class Main

    CONFIG_FILENAME = 'sanji.yml'


    def self.instance
      @instance ||= self.new
    end


    def initialize
      default_config = self.get_default_config_file
      user_config = self.get_user_config_file

      @config =
        if user_config.present?
          user_config.set_defaults_file default_config
          user_config
        else
          default_config
        end
    end

    def user_templates_path
      path = "#{self.user_home_path}/templates"
      ::File.directory?(path) ? path : nil
    end

    def user_recipes_path
      path = "#{self.user_home_path}/#{@config.recipes_path}"

      if @config.recipes_path.nil? || !::File.directory?(path)
        nil
      else
        path
      end
    end

    def set_cookbook_override cookbook_name
      @cookbook_override = cookbook_name
    end

    def preferred_cookbook
      return @preferred_cookbook if @preferred_cookbook

      cookbook_name = @cookbook_override || @config.preferred_cookbook

      @preferred_cookbook =
        CookbookBuilder.instance(@config).build cookbook_name
    end

    def recipe_classes
      @recipe_classes ||= self.preferred_cookbook.recipes.map(&:class_instance)
    end

    def optional_recipes
      @optional_recipes ||= self.preferred_cookbook.optional_recipes
    end

    def gem_groups
      @gem_groups ||= self.preferred_cookbook.gem_groups
    end



    protected

    def get_default_config_file
      home_path = "#{::File.dirname(__FILE__)}/../../"
      File.new "#{home_path}/#{CONFIG_FILENAME}"
    end

    def get_user_config_file
      filename = "#{self.user_home_path}/#{CONFIG_FILENAME}"

      if self.user_home_path.nil? || !::File.file?(filename)
        nil
      else
        File.new filename
      end
    end

    def user_home_path
      @user_home_path ||= ENV['SANJI_HOME']
    end

  end
end
