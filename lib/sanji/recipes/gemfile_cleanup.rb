class Sanji::Recipes::GemfileCleanup < Sanji::Recipe

  def after_everything
    @group_lines = {:global => []}
    @active_group = :global

    self.gemfile.each_line { |line| self.group_line line }
    self.rewrite_gemfile
  end



  protected

  def group_line line = ''
    return if self.is_blank_or_comment? line

    group_full_name = self.extract_group_full_name line

    if group_full_name.present?
      @active_group = group_full_name
    elsif line =~ /^end$\n?/
      @active_group = :global
    else
      @group_lines[@active_group] ||= []
      @group_lines[@active_group].push line
    end
  end

  def is_blank_or_comment? line = ''
    line =~ /^\s*#/ || line =~ /^\s*$\n/
  end

  # return example: ":development, :test"
  def extract_group_full_name line = ''
    if line =~ /^group.+do$\n/
      groups = line.scan(/:\w+/).sort
      full_name = groups.join ', '

      return full_name
    end

    nil
  end

  def rewrite_gemfile
    global_statements = @group_lines.delete :global
    global_statements.each { |line| self.new_gemfile << line }

    @group_lines.each do |group, lines|
      self.append_group_to_new_gemfile group, lines
    end

    a.replace_file_contents 'Gemfile', self.new_gemfile
  end

  def append_group_to_new_gemfile group, lines
    self.new_gemfile << "\ngroup #{group} do\n"
    lines.each { |line| self.new_gemfile << line }
    self.new_gemfile << "end\n"
  end

  def new_gemfile
    @new_gemfile ||= ''
  end

  def gemfile
    @gemfile ||= File.read a.destination_path('Gemfile')
  end

end
