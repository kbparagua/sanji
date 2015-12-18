class Sanji::Config::CookbookReference

  PREFIX = '@'


  def self.valid? string = ''
    string.start_with? PREFIX
  end



  def initialize value = ''
    @value = value
  end

  def belongs_to_sanji?
    self.cookbook_item.belongs_to_sanji?
  end

  def key_name
    self.cookbook_item.key_name
  end



  protected

  def cookbook_item
    @cookbook_item ||= Sanji::Config::Item.new(item_name)
  end

  def item_name
    @item_name ||= @value.sub(PREFIX, '')
  end

end
