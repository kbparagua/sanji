class Sanji::Assistant

  attr_accessor :active_recipe
  attr_reader :builder

  def self.initialize_instance builder
    @instance = self.new(builder)
  end

  def self.instance
    @instance
  end



  def initialize builder
    @builder = builder
  end

  def method_missing name, *args, &block
    self.builder.send name, *args, &block
  end



  def text &block
    Sanji::Utilities::Text.create &block
  end

  def generator name, value
    self.builder.insert_into_file 'config/application.rb',
      self.text { |t| t.indent(3).puts "g.#{name} #{value}" },
      :after => "# sanji-generators\n"
  end


  # `block` will have an Sanji::Utilities::Text instance as an argument.
  def application_config &block
    config = self.text &block

    self.builder.insert_into_file 'config/application.rb', config,
      :after => "class Application < Rails::Application\n"
  end

  def bundle_exec command = ''
    self.builder.run "bundle exec #{command}"
  end

  # NOTE: Need to manually do this because it appears that
  # bundler is adding `gem` method to all classes.
  #
  # Need to investigate further.
  def gem *args
    self.builder.gem *args
  end

  def remove_gem name
    self.builder.gsub_file 'Gemfile',
      Regexp.new("^\\s*gem ('|\")#{name}('|\").*\\n"), ''
  end

  def delete_file filename
    self.builder.run "rm #{filename}"
  end

  def log_start method_name
    self.say "start ##{method_name}"
  end

  def log_end method_name
    self.say "end ##{method_name}"
  end

  def say text
    self.builder.say recipe_message(text)
  end

  def ask question
    self.builder.ask recipe_message(apply_question_style(question))
  end

  def yes? question
    self.builder.yes? recipe_message(apply_question_style("#{question} (y/n)"))
  end

  def no? question
    self.builder.no? recipe_message(apply_question_style("#{question} (y/n)"))
  end



  private

  def apply_question_style string = ''
    "\e[30m\e[46m#{string}\e[0m"
  end

  def recipe_message message = ''
    "\e[1m\e[33m#{self.active_recipe.class.name} -> \e[0m #{message}"
  end

end
