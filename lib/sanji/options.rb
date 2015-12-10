class Sanji::Options

  DEFAULT_HOME_PATH = "#{File.dirname(__FILE__)}/../"
  HOME_PATH_ENV_VARIABLE = 'SANJI_HOME'

  CONFIG_FILENAME = 'sanji.yml'

  def self.instance
    @instance ||= self.new
  end



  def initialize
    @default_config = Sanji::Config.new "#{DEFAULT_HOME_PATH}/#{CONFIG_FILENAME}"
    @user_config = self.fetch_user_config
  end

  def user_recipes_path
    return nil if self.user_home_path.blank?
    "#{self.user_home_path}/#{@user_config.recipes_path}"
  end

  def cookbook
    return @cookbook if @cookbook

    cookbook_name = @user_config.cookbook || @default_config.cookbook
    @cookbook = Sanji::Item.new cookbook_name
  end

  def sanji_cookbook?
    self.cookbook.belongs_to_sanji?
  end

  def recipe_classes
    @recipes ||=
      self.cookbook_recipe_names.map do |recipe_name|
        self.get_recipe_class recipe_name
      end
  end

  def cookbook_recipe_names
    return @cookbook_entry if @cookbook_entry

    @cookbook_entry =
      if self.sanji_cookbook?
        @default_config.cookbooks[self.cookbook.key_name]
      else
        @user_config.cookbooks[self.cookbook.key_name]
      end
  end


  protected

  def user_home_path
    @user_home_path ||= ENV[HOME_PATH_ENV_VARIABLE]
  end

  def fetch_user_config
    filename =
      user_home_path ? "#{self.user_home_path}/#{CONFIG_FILENAME}" : nil

    Sanji::Config.new filename
  end

  def get_recipe_class recipe_name
    recipe = Sanji::Item.new recipe_name

    if recipe.belongs_to_sanji?
      Sanji::Recipes.const_get recipe.class_name
    else
      Sanji::Locals.const_get recipe.class_name
    end
  end

end
