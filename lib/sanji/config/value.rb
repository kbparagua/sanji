class Sanji::Config::Value

  SANJI_ITEM_PREFIX = '_'
  COOKBOOK_REFERENCE_PREFIX = '@'


  attr_reader :value


  def initialize value
    @value = value
  end

  def references_sanji_item?
    self.value.start_with? SANJI_ITEM_PREFIX
  end

  def references_cookbook?
    self.value.start_with? COOKBOOK_REFERENCE_PREFIX
  end

  def as_key
    return @key_name if @key_name

    @key_name = self.value

    @key_name.sub!(COOKBOOK_REFERENCE_PREFIX, '') if self.references_cookbook?
    @key_name.sub!(SANJI_ITEM_PREFIX, '') if self.references_sanji_item?

    @key_name
  end

  def as_class_name
    @class_name ||= self.key_name.camelize
  end

end
