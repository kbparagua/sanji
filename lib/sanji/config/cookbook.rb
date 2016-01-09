class Sanji::Config::Cookbook

  COOKBOOK_REFERENCE_PREFIX = '^'

  attr_reader :name


  def initialize name, contents = {}
    @name = name
    @contents = contents
    @included_cookbooks = {}
  end

  def include_cookbook cookbook
    @included_cookbooks[cookbook.name] = cookbook
  end

  def recipes
    @recipes ||=
      @contents['recipes'].flat_map do |value|
        self.create_recipe value
      end
  end



  protected

  def create_recipe recipe_or_reference
    if recipe_or_reference.start_with? COOKBOOK_REFERENCE_PREFIX
      self.create_recipes_from_cookbook recipe_or_reference
    else
      Sanji::Config::Recipe.new recipe_or_reference
    end
  end

  def create_recipes_from_cookbook reference
    name = reference.sub COOKBOOK_REFERENCE_PREFIX, ''

    unless @included_cookbooks.has_key? name
      raise "You failed to include cookbook: #{name}."
    end

    cookbook = @included_cookbooks[name]
    cookbook.recipes
  end

end
