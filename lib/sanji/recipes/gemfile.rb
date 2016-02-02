class Sanji::Recipes::Gemfile < Sanji::Recipe

  def after_create
    gem_envs = {}

    Sanji::Config::Main.instance.gem_groups.each do |env, gems|
      gems.each do |gem_name|
        gem_envs[gem_name] ||= []
        gem_envs[gem_name].push env
      end
    end

    gem_groups = {}

    gem_envs.each do |gem_name, envs|
      # if gem is included in `all` environment, then including it in any
      # environment will not matter.
      group_name = envs.include?('all') ? 'all' : envs.sort.join(', ')
      gem_groups[group_name] ||= []
      gem_groups[group_name].push gem_name
    end

    # NOTE:
    # gem_groups at this point will be equal to something like this:
    # {
    #   "all" => ["thin", "paperclip", "kaminari"],
    #   "development, test" => ["quiet_assets"]
    # }
  end

end
