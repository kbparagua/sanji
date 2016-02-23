class Sanji::Recipes::Gemfile < Sanji::Recipe

  GLOBAL_SCOPE = 'global'
  GLOBAL_GEM_PATTERN = /^gem (.)+\n/

  def after_create
    self.gem_groups.each do |group, gems|
      gem_list = gems.map { |gem_object| "\t#{gem_object.as_gemfile_entry}" }

      if self.global? group
        # Remove tab character from gems.
        self.insert_gems gem_list.map(&:lstrip)
      else
        self.insert_group group, gem_list
      end
    end

    # Clear file contents
    a.gsub_file 'Gemfile', /(\s|\S)*/, ''
    a.append_to_file 'Gemfile', self.gemfile
  end


  protected

  def insert_gems gem_list = []
    first_global_gem = self.gemfile[/^gem (.)+\n/]

    insert_at_index =
      self.gemfile.index(first_global_gem) +
      first_global_gem.length

    self.gemfile.insert insert_at_index, gem_list.join
  end

  def insert_group group, gem_list = []
    header = self.group_header group
    header_index = self.gemfile.index header

    if header_index.present?
      insert_at_index = header_index + header.length
      self.gemfile.insert insert_at_index, gem_list.join
    else
      self.gemfile << header
      self.gemfile << gem_list.join
      self.gemfile << "end\n"
    end
  end

  def global? group = []
    group.include? GLOBAL_SCOPE
  end

  def group_header group = []
    header = 'group '

    envs = group.map { |env| ":#{env}" }.join ', '
    header << "#{envs} do\n"

    header
  end

  # {
  #   ['global'] => [gem1, gem2, gem3],
  #   ['development', 'test'] => [gem1, gem2]
  # }
  def gem_groups
    @gem_groups ||= Sanji::Config::Main.instance.gem_groups
  end

  def gemfile
    @gemfile ||= File.read("#{a.destination_root}/Gemfile")
  end

end
