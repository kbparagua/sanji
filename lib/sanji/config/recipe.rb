class Sanji::Config::Recipe

  SANJI_PREFIX = '_'

  attr_reader :name


  def initialize name
    @name = name
  end

  def full_class_name
    @full_class_name ||=
      if self.belongs_to_sanji?
        "Sanji::Recipes::#{self.class_name}"
      else
        self.class_name
      end
  end

  def class_instance
    @class_instance ||= self.full_class_name.constantize
  end



  protected

  def class_name
    @class_name ||= self.name_without_prefix.camelize
  end

  def name_without_prefix
    if self.belongs_to_sanji?
      self.name.sub SANJI_PREFIX, ''
    else
      self.name
    end
  end

  def belongs_to_sanji?
    self.name.start_with? SANJI_PREFIX
  end

end

