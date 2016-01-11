class Sanji::Config::CookbookBuilder

  def initialize config
    @config = config
  end

  def build name = ''
    entry = @config.cookbook_by_name name
    cookbook = Sanji::Config::Cookbook.new name, entry

    return cookbook if entry['include'].blank?

    entry['include'].each do |cookbook_name|
      other_cookbook = self.class.new(@config).build cookbook_name
      cookbook.include_cookbook other_cookbook
    end

    cookbook
  end

end
