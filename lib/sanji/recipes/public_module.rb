class Sanji::Recipes::PublicModule < Sanji::Recipe

  def after_bundle
    self.create_public_module if self.create_public_module?
    self.create_home if self.create_home?
  end


  protected

  def create_public_module?
    if @create_public_module.nil?
      @create_public_module = a.yes? 'Create public module for controllers?'
    end

    @create_public_module
  end

  def create_public_module
    a.generate 'controller', 'public/base'

    # Remove base folder create by generate.
    a.inside 'app/views/public' do
      a.run 'rm -R base'
    end
  end

  def create_home?
    a.yes? 'Create public home controller?'
  end

  def create_home
    if self.create_public_module?
      self.create_home_inside_module
    else
      self.create_home_outside_module
    end
  end

  def create_home_inside_module
    a.generate 'controller', 'public/home', 'index'

    a.gsub_file 'app/controllers/public/home_controller.rb',
      /ApplicationController/,
      'Public::BaseController'

    a.route "root :to => 'public/home#index'"

    # Change public namespace created by generate to module.
    a.gsub_file 'config/routes.rb',
      /namespace :public/,
      'scope :module => :public'

    # Remove route created by 'public/home index'
    a.gsub_file 'config/routes.rb', /get 'home\/index'/, ''
  end

  def create_home_outside_module
    a.generate 'controller', 'home', 'index'

    # Remove route created by 'home index'
    a.gsub_file 'config/routes.rb', /get 'home\/index'/, ''

    a.route "root :to => 'home#index'"
  end

end
