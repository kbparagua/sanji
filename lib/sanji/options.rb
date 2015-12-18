class Sanji::Options

  DEFAULT_HOME_PATH = "#{File.dirname(__FILE__)}/../"
  HOME_PATH_ENV_VARIABLE = 'SANJI_HOME'

  CONFIG_FILENAME = 'sanji.yml'


  def self.instance
    @instance ||= self.new
  end



  def initialize
    @default_config = Sanji::Config::File.new "#{DEFAULT_HOME_PATH}/#{CONFIG_FILENAME}"
    @user_config = self.fetch_user_config
  end

  def user_recipes_path
    return nil if self.user_home_path.blank?
    "#{self.user_home_path}/#{@user_config.recipes_path}"
  end

  def recipe_classes
    @recipes ||=
      self.recipe_names.map do |recipe_name|
        self.get_recipe_class recipe_name
      end
  end

  def optional? recipe_class
    self.optional_recipe_classes.include? recipe_class
  end



  protected

  def recipe_names
    @recipe_names ||= self.cookbook_entry['recipes']
  end

  def optional_recipe_classes
    return [] unless self.cookbook_entry.has_key?('optional')

    @optional_recipe_classes ||=
      self.cookbook_entry['optional'].map do |recipe_name|
        self.get_recipe_class recipe_name
      end
  end

  def cookbook_entry
    return @cookbook_entry if @cookbook_entry

    @cookbook_entry =
      if self.cookbook.belongs_to_sanji?
        @default_config.cookbooks[self.cookbook.key_name]
      else
        @user_config.cookbooks[self.cookbook.key_name]
      end
  end

  def cookbook
    return @cookbook if @cookbook

    cookbook_name = @user_config.cookbook || @default_config.cookbook
    @cookbook = Sanji::Config::Item.new cookbook_name
  end

  def get_recipe_class recipe_name
    recipe = Sanji::Config::Item.new recipe_name

    if recipe.belongs_to_sanji?
      Sanji::Recipes.const_get recipe.class_name
    else
      Sanji::Locals.const_get recipe.class_name
    end
  end

  def fetch_user_config
    filename =
      user_home_path ? "#{self.user_home_path}/#{CONFIG_FILENAME}" : nil

    Sanji::Config::File.new filename
  end

  def user_home_path
    @user_home_path ||= ENV[HOME_PATH_ENV_VARIABLE]
  end

end
