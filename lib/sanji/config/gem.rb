class Sanji::Config::Gem

  attr_reader :name


  def initialize name = ''
    @name = name
  end

  def equal? other_gem
    self.name == other_gem.name
  end

end
