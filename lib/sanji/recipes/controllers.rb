class Sanji::Recipes::Controllers < Sanji::Recipe

  def after_bundle
    self.setup_public

    self.setup_admin if self.has_admin?
    self.setup_private if self.has_private?
  end

  protected

  def has_admin?
    a.yes? 'Create admin namespace?'
  end

  def has_private?
    a.yes? 'Create private module for logged-in non-admin users?'
  end

  def has_homepage?
    a.yes? 'Create controller for public home page?'
  end

  def setup_admin
    a.generate 'controller', 'admin/base'

    a.inside 'app/views/admin' do
      a.run 'rm -R base'
    end

    route =
      a.text do |t|
        t.indent.puts 'namespace :admin do'
        t.indent.puts 'end'
      end

    a.route route
  end

  def setup_private
    a.generate 'controller', 'private/base'

    a.inside 'app/views/private' do
      a.run 'rm -R base'
    end

    route =
      a.text do |t|
        t.indent.puts 'scope :module => :private do'
        t.indent.puts 'end'
      end

    a.route route
  end

  def setup_public
    a.generate 'controller', 'public/base'

    a.inside 'app/views/public' do
      a.run 'rm -R base'
    end

    if self.has_homepage?
      a.copy_file 'public_home_controller.rb',
        'app/controller/public/home_controller.rb'

      a.template 'public_home_index.haml.erb', 'app/views/public/home/index.haml'

      a.route "root :to => 'public/home#index'"

      # Change public namespace to module only.
      a.gsub_file 'config/routes.rb',
        /namespace :public/,
        'scope :module => :public'
    else
      a.route "scope :module => :public do\n  end"
    end
  end

end
