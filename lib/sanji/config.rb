require 'yaml'

class Sanji::Config

  attr_reader :contents

  def initialize filename = nil
    @contents = YAML.load_file(filename) if filename.present?
  end

  def cookbook
    self.contents['cookbook'] if self.contents
  end

  def cookbooks
    self.contents['cookbooks'] if self.contents
  end

  def has_cookbook? name
    return false unless self.contents
    self.cookbooks.has_key? name.to_s
  end

  def recipes
    return [] unless self.contents
    self.cookbooks[self.cookbook]
  end

end
