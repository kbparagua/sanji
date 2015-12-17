class Sanji::Recipes::GemfileCleanup < Sanji::Recipe

  def after_everything
    @gemfile = File.read self.gemfile_path
    @new_gemfile = ''

    @group_lines = {:global => []}
    @active_group = :global

    @gemfile.each_line { |line| self.group_line line }

    self.rewrite_gemfile
  end



  protected

  def gemfile_path
    @gemfile_path ||= "#{a.destination_root}/Gemfile"
  end

  def group_line line = ''
    # Ignore comments and empty lines
    return if line =~ /^\s*#/ || line =~ /^\s*$\n/

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

  def extract_group_full_name line = ''
    if line =~ /^group.+do$\n/
      groups = line.scan(/:\w+/).sort
      full_name = groups.join ', '

      return full_name
    end

    nil
  end

  def rewrite_gemfile
    self.erase_gemfile_contents

    global_statements = @group_lines.delete :global
    global_statements.each { |line| @new_gemfile << line }

    @group_lines.each do |group, lines|
      self.append_group_to_new_gemfile group, lines
    end

    a.append_to_file 'Gemfile', @new_gemfile
  end

  def erase_gemfile_contents
    File.open(self.gemfile_path, 'w'){}
  end

  def append_group_to_new_gemfile group, lines
    @new_gemfile << "\ngroup #{group} do\n"

    lines.each { |line| @new_gemfile << line }

    @new_gemfile << "end\n"
  end

end
