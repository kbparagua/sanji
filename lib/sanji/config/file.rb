require 'yaml'

class Sanji::Config::File

  SANJI_COOKBOOK_PREFIX = '_'


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
    @cookbook_entries = {}
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

  def cookbook_by_name name
    self.cookbook_by_key name.sub(SANJI_COOKBOOK_PREFIX, '')
  end

  def cookbook_by_key key_name
    key = key_name.to_s
    return @cookbook_entries[key] if @cookbook_entries[key]

    instance =
      if self.has_cookbook? key
        @cookbooks[key]
      elsif @defaults.present? && @defaults.has_cookbook?(key)
        @defaults.cookbook key
      else
        raise "Invalid cookbook: #{key}"
      end

    @cookbook_entries[key] = instance
  end

  def has_cookbook? key_name
    @cookbooks.has_key? key_name.to_s
  end

end
