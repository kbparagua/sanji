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



  def generator name, value
    app_rb_path = self.destination_path '/config/application.rb'
    app_rb = File.read app_rb_path

    if app_rb.include? 'config.generators'
      self.builder.insert_into_file 'config/application.rb',
        "#{tab 3}g.#{name} #{value}\n",
        :after => /config\.generators do \|g\|\n/
    else
      config =
        "config.generators do |g|\n" \
        "#{tab}g.#{name} #{value}\n" \
        "end\n"

      self.application_config config
    end
  end

  def application_config text = ''
    lines = text.split "\n"
    indented_text = lines.map { |line| "#{tab 2}#{line}"}.join "\n"
    indented_text << "\n"

    self.builder.insert_into_file 'config/application.rb',
      indented_text,
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

  def erase_file_contents path
    File.open(self.destination_path(path), 'w'){}
  end

  def replace_file_contents path, new_content
    self.erase_file_contents path
    self.builder.append_to_file path, new_content
  end

  def destination_path path = ''
    [self.builder.destination_root, path].join '/'
  end

  def delete_file filename
    self.builder.run "rm #{filename}"
  end

  def log_start method_name
    self.say "##{method_name} [start]"
  end

  def log_end method_name
    self.say "##{method_name} [end]"
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

  def tab number = 1
    '  ' * number
  end



  private

  def apply_question_style string = ''
    "\e[30m\e[46m#{string}\e[0m"
  end

  def recipe_message message = ''
    "\e[1m\e[33m#{self.active_recipe.class.name} -> \e[0m #{message}"
  end

end
