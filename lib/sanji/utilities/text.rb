class Sanji::Utilities::Text

  attr_reader :value


  def self.create &block
    instance = self.new
    block.call instance

    instance.value
  end


  def initialize
    @value = ''
  end

  def puts text = ''
    self.value << "#{text}\n"
    self
  end

  def print text = ''
    self.value << "#{text}"
    self
  end

  def indent quantity = 1
    self.value << ('  ' * quantity)
    self
  end

  def empty_line
    self.puts
  end

end
