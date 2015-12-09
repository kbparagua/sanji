class Sanji::Options

  DEFAULT_HOME_PATH = "#{File.dirname(__FILE__)}/../"
  HOME_PATH_ENV_VARIABLE = 'SANJI_HOME'

  CONFIG_FILENAME = 'sanji.yml'
  SANJI_ITEMS_PREFIX = '_'


  def self.instance
    @instance ||= self.new
  end



  def initialize
    @default_config = Sanji::Config.new "#{DEFAULT_HOME_PATH}/#{CONFIG_FILENAME}"
    @user_config = self.fetch_user_config
  end

  def cookbook
    @cookbook ||= @user_config.cookbook || @default_config.cookbook
  end

  def sanji_cookbook?
    self.is_sanji_item? self.cookbook
  end

  def recipe_classes
    @recipes ||=
      self.cookbook_recipe_names.map do |recipe_name|
        self.get_recipe_class recipe_name
      end
  end

  def cookbook_recipe_names
    return @cookbook_entry if @cookbook_entry

    cookbook_valid_name = self.valid_item_name self.cookbook

    @cookbook_entry =
      if self.sanji_cookbook?
        @default_config.cookbooks[cookbook_valid_name]
      else
        @user_config.cookbooks[cookbook_valid_name]
      end
  end


  protected

  def fetch_user_config
    user_home_path = ENV[HOME_PATH_ENV_VARIABLE]
    filename = user_home_path ? "#{user_home_path}/#{CONFIG_FILENAME}" : nil

    Sanji::Config.new filename
  end

  def is_sanji_item? item_name
    item_name.start_with? SANJI_ITEMS_PREFIX
  end

  def valid_item_name item_name
    if self.is_sanji_item? item_name
      return item_name.sub SANJI_ITEMS_PREFIX, ''
    end

    item_name
  end

  def get_recipe_class name
    recipe_valid_name = self.valid_item_name name
    recipe_class_name = recipe_valid_name.camelize

    if self.is_sanji_item? name
      Sanji::Recipes.const_get recipe_class_name
    else
      Sanji::Locals.const_get recipe_class_name
    end
  end

end
