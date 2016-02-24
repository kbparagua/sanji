class Sanji::Recipes::Gemfile < Sanji::Recipe

  GLOBAL_SCOPE = 'global'


  def after_create
    self.gem_groups.each do |group, gems|
      if self.global? group
        self.insert_gems gems
      else
        self.insert_group group, gems
      end
    end

    a.replace_file_content 'Gemfile', self.gemfile
  end


  protected

  def insert_gems gems
    gem_list = gems.map(&:as_gemfile_entry).join
    self.gemfile << "\n#{gem_list}"
  end

  def insert_group group, gems = []
    gem_list = gems.map { |g| "\t#{g.as_gemfile_entry}" }.join

    self.gemfile << self.group_header(group)
    self.gemfile << gem_list
    self.gemfile << "end\n"
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
