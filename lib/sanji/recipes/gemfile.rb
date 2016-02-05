class Sanji::Recipes::Gemfile < Sanji::Recipe

  def after_create
    raise self.gem_groups.inspect

    self.gem_groups.each do |envs, gems|
      group = self.to_group_name envs

      a.say "Group: #{group}\n"

      gems.each do |g|
        a.say g
      end
    end

  end


  protected

  def to_group_name envs = []
    return nil if envs.include? 'all'
    envs.map { |env| ":#{env}" }.join ', '
  end

  def gem_groups
    return @gem_groups if @gem_groups
    @gem_groups = {}

    self.gem_groups_data.each do |group, data|
      @gem_groups[ data[:envs] ] = data[:gems]
    end

    @gem_groups
  end

  # {
  #   'development-test' =>
  #      {:envs => ['development', 'test'], :gems => [gem1, gem2]},
  #   'all-development' =>
  #      {:envs => ['all', 'development'], :gems => [gem4]}
  # }
  def gem_groups_data
    return @gem_groups_data if @gem_groups_data

    @gem_groups_data = {}

    self.envs_by_gem.each do |gem_name, envs|
      # Ignore other environment if all/global is included.
      envs = ['all'] if envs.include? 'all'

      sorted_envs = envs.sort
      group_id = sorted_envs.join '-'

      @gem_groups_data[group_id] ||= {:envs => sorted_envs, :gems => []}
      @gem_groups_data[group_id][:gems] << gem_name
    end

    @gem_groups_data
  end


  # {
  #   "gem1" => ["development", "test"],
  #   "gem2" => ["all", "test"],
  #   "gem3" => ["development"]
  # }
  def envs_by_gem
    return @envs_by_gem if @envs_by_gem
    @envs_by_gem = {}

    self.gems_by_env.each do |env, gems|
      gems.each do |name|
        @envs_by_gem[name] ||= []
        @envs_by_gem[name] << env
      end
    end

    @envs_by_gem
  end

  # {
  #   "all" => [gem1, gem2, gem3],
  #   "development" => [gem1, gem2],
  #   "test" => [gem1]
  # }
  def gems_by_env
    @gems_by_env ||= Sanji::Config::Main.instance.gems_by_env
  end

end
