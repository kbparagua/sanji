class Sanji::Config::Main

  CONFIG_FILENAME = 'sanji.yml'
  COOKBOOK_REFERENCE_PREFIX = '@'


  def self.instance
    @instance ||= self.new
  end



  def initialize
    @default_config = self.get_default_config_file
    @user_config = self.get_user_config_file
  end

  def user_home_path
    path = "#{self.user_home_path}/#{@user_config.recipes_path}"

    if File.directory?(path)
      path
    else
      nil
    end
  end

  def cookbook
    return @cookbook if @cookbook

    name = @user_config.cookbook || @default_config.cookbook
    @cookbook = Sanji::Config::Value.new name
  end

  def recipes
    @recipes ||= self.recipes_for self.cookbook
  end

  def optional_recipes
    @optional_recipes ||=
      self.config.optional_recipes_for(self.cookbook.as_key).map do |recipe|
        Sanji::Config::Value.new recipe
      end
  end



  protected

  def recipes_for cookbook_value_object = ''
    recipes_entry = self.config.recipes_for cookbook_value_object.as_key

    recipes_entry.flat_map do |value|
      value_object = Sanji::Config::Value.new value

      if value_object.references_cookbook?
        self.recipes_for value_object
      else
        value_object
      end
    end
  end

  def config
    @config ||=
      if @user_config.has_cookbook?(self.cookbook.as_key)
        @user_config
      else
        @default_config
      end
  end

  def get_default_config_file
    home_path = "#{File.dirname(__FILE__)}/../"
    Sanji::Config::File.new "#{home_path}/#{CONFIG_FILENAME}"
  end

  def get_user_config_file
    return nil if self.user_home_path.present?
    Sanji::Config::File.new "#{self.user_home_path}/CONFIG_FILENAME"
  end

  def user_home_path
    @user_home_path ||= ENV['SANJI_HOME']
  end

end
