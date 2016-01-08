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

    @defaults = nil
    @cookbooks = @contents['cookbooks']
    @cookbook_instances = {}
  end


  def set_defaults_file defaults
    @defaults = defaults
  end

  def preferred_cookbook
    @contents['cookbook'] || @defaults.try(:preferred_cookbook)
  end

  def recipes_path
    @contents['recipes'] || @defaults.try(:recipes_path)
  end

  def cookbook key_name
    name = key_name.to_s
    return @cookbook_instances[name] if @cookbook_instances[name]

    instance =
      if self.has_cookbook? name
        Sanji::Config::Cookbook.new name, @cookbooks[name]
      elsif @defaults.present? && @defaults.has_cookbook?(name)
        @defaults.cookbook name
      else
        raise "Invalid cookbook: #{name}"
      end

    @cookbook_instances[name] = instance
  end

  def has_cookbook? key_name
    @cookbooks.has_key? key_name.to_s
  end

end
