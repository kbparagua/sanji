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

  def optional_recipes
    return @optional_recipes if @optional_recipes

    optional = @contents['optional'] || []
    optional.map! { |name| Sanji::Config::Recipe.new name }

    @included_cookbooks.each do |_, cookbook|
      optional += cookbook.optional_recipes
    end

    @optional_recipes = optional
  end

  def gem_groups
    return @gem_groups if @gem_groups

    @gem_groups = self.own_gem_groups

    @included_cookbooks.each do |_, cookbook|
      cookbook.gem_groups.each do |group, gems|
        @gem_groups[group] ||= []
        @gem_groups[group] += gems
      end
    end

    @gem_groups
  end



  protected

  def own_gem_groups
    gems_by_group_name = @contents['gems'] || {}

    gem_groups = {}

    gems_by_group_name.each do |group_name, gem_full_names|
      group = group_name.split(' ').map &:strip
      gem_groups[group] ||= []
      gem_groups[group] += gem_full_names.map { |fn| Sanji::Config::Gem.new fn }
    end

    gem_groups
  end

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
