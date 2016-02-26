require 'yaml'

class Sanji::Config::File

  SANJI_COOKBOOK_PREFIX = '_'

  def initialize filename
    @contents = self.get_contents filename

    @cookbooks = @contents['cookbooks'] || {}
    @cookbook_entries = {}

    @defaults = nil
  end

  # @defaults is an instance of Sanji::Config::File
  # that will be used when something is not found on
  # this file.
  def set_defaults_file defaults
    @defaults = defaults
  end

  def preferred_cookbook
    @contents['cookbook'] || @defaults.try(:preferred_cookbook)
  end

  def recipes_path
    @contents['recipes'] || @defaults.try(:recipes_path)
  end

  def cookbook_entry name = ''
    key = name.to_s
    return @cookbook_entries[key] if @cookbook_entries[key]

    entry = @cookbooks[key] || @defaults.try(:cookbook_entry, key)
    raise "Invalid cookbook: #{key}" if entry.nil?

    @cookbook_entries[key] = entry
  end

  def has_cookbook? name = ''
    @cookbooks.has_key? name.to_s
  end


  protected

  def get_contents filename = ''
    if ::File.file? filename.to_s
      YAML.load_file filename
    else
      raise "Missing config file: #{filename}"
    end
  end

end
