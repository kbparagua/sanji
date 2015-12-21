require 'yaml'

class Sanji::Config::File

  attr_reader :contents

  def initialize filename = nil
    @contents =
      if ::File.file? filename.to_s
        YAML.load_file filename
      else
        nil
      end
  end

  def cookbook
    return nil unless self.contents
    self.contents['cookbook']
  end

  def cookbooks
    return nil unless self.contents
    self.contents['cookbooks']
  end

  def has_cookbook? key_name
    return false unless self.contents
    self.cookbooks.has_key? key_name.to_s
  end

  def recipes_for cookbook_key_name
    return nil unless self.contents
    self.cookbooks[cookbook_key_name]['recipes']
  end

  def optional_recipes_for cookbook_key_name
    return [] unless self.contents
    self.cookbooks[cookbook_key_name]['optional']
  end

  def recipes_path
    return nil unless self.contents
    self.contents['recipes']
  end

end
