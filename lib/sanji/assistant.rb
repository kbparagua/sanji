class Sanji::Assistant

  attr_reader :builder

  def initialize builder
    @builder = builder
  end

  def method_missing name, *args, &block
    self.builder.send name, *args, &block
  rescue
    super
  end


  def log_start method_name
    self.say "start ##{method_name}"
  end

  def log_end method_name
    self.say "end ##{method_name}"
  end

  def say text
    complete_text = "#{self.class.name} -> #{text}"
    self.builder.say complete_text, Thor::Shell::Color::YELLOW
  end

  def text &block
    Sanji::Utilities::Text.create &block
  end

  def generator name, value
    self.builder.insert_into_file 'config/application.rb',
      self.text { |t| t.indent(3).puts "g.#{name} #{value}" },
      :after => "# sanji-generators\n"
  end

end
