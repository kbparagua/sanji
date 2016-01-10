class Sanji::Config::Recipe

  SANJI_RECIPE_PREFIX = '_'

  attr_reader :name


  def initialize name
    @name = name
  end

  def full_class_name
    @full_class_name ||=
      if self.belongs_to_sanji?
        "Sanji::Recipes::#{self.class_name}"
      else
        "Sanji::Locals::#{self.class_name}"
      end
  end

  def class_name
    @class_name ||= self.key_name.camelize
  end

  def key_name
    @key_name ||=
      if self.belongs_to_sanji?
        self.name.sub SANJI_RECIPE_PREFIX, ''
      else
        self.name
      end
  end

  def belongs_to_sanji?
    self.name.start_with? SANJI_RECIPE_PREFIX
  end

end

