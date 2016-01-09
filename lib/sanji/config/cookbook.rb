class Sanji::Config::Cookbook

  def initialize name, contents = {}
    @name = name
    @contents = contents
    @included_cookbooks = []
  end

  def include_cookbook cookbook
    @included_cookbooks.push cookbook
  end

  def recipes
    @recipes ||=
      @contents['recipes'].map do |name|
        Sanji::Config::Recipe.new name
      end
  end

end
