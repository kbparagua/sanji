class Sanji::Options

  def self.instance
    @instance ||= self.new
  end



  def recipe_classes
    @recipe_classes ||=
      Sanji::Config::Main.instance.recipes.map do |recipe|
        recipe.full_class_name.constantize
      end
  end

  def optional? recipe_class
    self.optional_recipe_classes.include? recipe_class.name.demodulize
  end



  protected

  def optional_recipe_classes
    @optional_recipe_classes ||=
      Sanji::Config::Main.instance.optional_recipes.map(&:class_name)
  end

end
