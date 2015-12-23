require 'yaml'

class Sanji::Config::File

  attr_reader :contents

  def initialize filename
    @contents =
      if ::File.file? filename.to_s
        YAML.load_file filename
      else
        raise "Missing config file: #{filename}"
      end
  end

  def cookbook
    self.contents['cookbook'] if self.contents
  end

  def has_cookbook? key_name
    self.cookbooks.has_key? key_name.to_s
  end

  def recipes_for cookbook_key_name
    raise 'Invalid cookbook.' unless self.has_cookbook? cookbook_key_name
    self.cookbooks[cookbook_key_name]['recipes']
  end

  def optional_recipes_for cookbook_key_name
    self.cookbooks[cookbook_key_name]['optional']
  end

  def recipes_path
    self.contents['recipes']
  end



  protected

  def cookbooks
    self.contents['cookbooks']
  end


end
