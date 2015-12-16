class Sanji::Recipes::Cleanup < Sanji::Recipe

  def after_everything
    # remove all helper comments from Setup recipe.
    [
      'config/application.rb',
      'Gemfile'
    ].each { |file| a.gsub_file file, /^\s*# sanji.*\n/, '' }

    self.remove_gemfile_comments

    gemfile = File.read "#{a.destination_root}/Gemfile"

    gem_groups = {:root => []}
    active_group = :root
    gemfile.each_line do |line|
      if line == self.group_header(:development, :test)
        active_group = ':development, :test'
        next
      elsif line == self.group_header(:development)
        active_group = ':development'
        next
      elsif line == self.group_header(:test)
        active_group = ':test'
        next
      end

      if line == "end\n"
        active_group = :root
        next
      end

      gem_groups[active_group] ||= []
      gem_groups[active_group].push line
    end

    File.open("#{a.destination_root}/Gemfile", 'w'){ |f| f.truncate(0) }

    non_group_statements = gem_groups.delete :root
    non_group_statements.each do |line|
      line = "#{line}\n" unless line.include?("\n")
      a.append_to_file 'Gemfile', line
    end

    gem_groups.each do |group, lines|
      a.append_to_file 'Gemfile', "group #{group} do\n"

      lines.each do |line|
        line = "#{line}\n" unless line.include?("\n")
        a.append_to_file 'Gemfile', line
      end

      a.append_to_file 'Gemfile', "end\n"
    end
  end

  protected

  def remove_gemfile_comments
    a.gsub_file 'Gemfile', /^\s*#.*\n/, ''
  end

  def group_header *groups
    group_string = groups.map { |g| ":#{g}" }.join ', '
    "group #{group_string} do\n"
  end

end
