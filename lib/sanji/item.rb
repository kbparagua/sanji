class Sanji::Item

  SANJI_ITEM_PREFIX = '_'

  attr_reader :name


  def initialize name
    @name = name
  end

  def belongs_to_sanji?
    self.name.start_with? SANJI_ITEM_PREFIX
  end

  def key_name
    return self.name unless self.belongs_to_sanji?

    @key_name ||= self.name.sub(SANJI_ITEM_PREFIX, '')
  end

  def class_name
    @class_name ||= self.key_name.camelize
  end

end
