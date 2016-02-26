module Sanji::Config
  class Cookbook

    attr_reader :name


    def initialize name, contents = {}
      @name = name
      @contents = contents
      @included_cookbooks = []
    end

    def include_cookbook cookbook
      @included_cookbooks << cookbook
    end

    def recipes
      @recipes ||= self.included_recipes + self.own_recipes
    end

    def optional_recipes
      @optional_recipes ||=
        self.included_optional_recipes + self.own_optional_recipes
    end

    def gem_groups
      @gem_groups ||=
        self.own_gem_groups.merge(self.included_gem_groups) do |key, own, other|
          own + other
        end
    end



    protected

    def own_recipes
      @contents['recipes'].map { |recipe| Recipe.new recipe }
    end

    def own_optional_recipes
      result = @contents['optional'] || []
      result.map { |name| Recipe.new name }
    end

    def own_gem_groups
      gems_by_group_name = @contents['gems'] || {}

      gem_groups = {}

      gems_by_group_name.each do |group_name, gem_full_names|
        group = group_name.split(' ').map &:strip
        gem_groups[group] ||= []
        gem_groups[group] += gem_full_names.map { |fn| Gem.new fn }
      end

      gem_groups
    end

    def included_recipes
      @included_cookbooks.flat_map &:recipes
    end

    def included_optional_recipes
      @included_cookbooks.flat_map &:optional_recipes
    end

    def included_gem_groups
      gems_by_group = {}

      @included_cookbooks.each do |cookbook|
        cookbook.gem_groups.each do |group, gems|
          gems_by_group[group] ||= []
          gems_by_group[group] += gems
        end
      end

      gems_by_group
    end

  end
end
