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

    @cookbooks = @contents['cookbooks']
    @cookbook_instances = {}
  end



  def preferred_cookbook
    @contents['cookbook']
  end

  def recipes_path
    @contents['recipes']
  end

  def cookbook key_name
    raise "Invalid cookbook: #{key_name}." unless self.has_cookbook? key_name

    name = key_name.to_s
    return @cookbook_instances[name] if @cookbook_instances[name]

    instance = Sanji::Config::Cookbook.new name, @cookbooks[name]
    @cookbook_instances[name] = instance

    instance
  end

  def has_cookbook? key_name
    @cookbooks.has_key? key_name.to_s
  end

end
