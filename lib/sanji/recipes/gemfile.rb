class Sanji::Recipes::Gemfile < Sanji::Recipe

  GLOBAL_SCOPE = 'global'

  def after_create
    self.gem_groups.each do |group, gems|
      group_block = ''

      if self.global_group? group
        gems.each { |name| group_block << "gem '#{name}'\n" }
      else
        group_block << self.group_header(group)
        gems.each { |name| group_block << "\tgem '#{name}'\n" }
        group_block << "end\n"
      end

      a.append_to_file 'Gemfile', group_block
    end
  end


  protected

  def global_group? group = []
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

end
