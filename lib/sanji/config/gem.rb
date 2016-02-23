class Sanji::Config::Gem

  attr_reader :full_name


  def initialize full_name = ''
    @full_name = full_name
    @parts = full_name.split ','
  end

  def name
    @name ||= @parts.first.strip
  end

  def version
    return nil if @parts.length <= 1
    @version ||= @parts.last.strip
  end

  def as_gemfile_entry
    entry = [self.name, self.version].compact.map { |str| "'#{str}'" }.join ', '
    "gem #{entry}\n"
  end

  def equal? other_gem
    self.full_name == other_gem.full_name
  end

end
