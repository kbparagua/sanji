class Sanji::Config::Main

  CONFIG_FILENAME = 'sanji.yml'
  # COOKBOOK_REFERENCE_PREFIX = '@'


  def self.instance
    @instance ||= self.new
  end



  def initialize
    @default_config = self.get_default_config_file
    @user_config = self.get_user_config_file
  end

  def user_recipes_path
    path = "#{self.user_home_path}/#{@user_config.recipes_path}"

    if @user_config.recipes_path.nil? || !::File.directory?(path)
      nil
    else
      path
    end
  end

  def recipes
    @recipes ||= self.preferred_cookbook.recipes
  end

  def optional_recipes
    @optional_recipes ||= self.preferred_cookbook.optional_recipes
  end



  protected

  def preferred_cookbook
    return @preferred_cookbook if @preferred_cookbook

    name = @user_config.preferred_cookbook || @default_config.preferred_cookbook
    key_name = Sanji::Config::Value.new(name).as_key

    source =
      @user_config.has_cookbook?(key_name) ? @user_config : @default_config

    @preferred_cookbook = source.cookbook key_name
  end

  def get_default_config_file
    home_path = "#{File.dirname(__FILE__)}/../../"
    Sanji::Config::File.new "#{home_path}/#{CONFIG_FILENAME}"
  end

  def get_user_config_file
    filename = "#{self.user_home_path}/#{CONFIG_FILENAME}"

    if self.user_home_path.nil? || !::File.file?(filename)
      Sanji::Config::BlankFile.new
    else
      Sanji::Config::File.new filename
    end
  end

  def user_home_path
    @user_home_path ||= ENV['SANJI_HOME']
  end

end
