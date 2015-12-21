class Sanji::Options

  def self.instance
    @instance ||= self.new
  end



  def recipe_classes
    @recipe_classes ||=
      Sanji::Config::Main.instance.recipes.map do |recipe|
        self.get_recipe_class recipe
      end
  end

  def optional? recipe_class
    self.optional_recipe_classes.include? recipe_class.to_s
  end



  protected

  def optional_recipe_classes
    @optional_recipe_classes ||=
      Sanji::Config::Main.instance.optional_recipes.map(&:as_class_name)
  end

  def get_recipe_class recipe = nil
    if recipe.references_sanji_item?
      Sanji::Recipes.const_get recipe.as_class_name
    else
      Sanji::Locals.const_get recipe.as_class_name
    end
  end

end
