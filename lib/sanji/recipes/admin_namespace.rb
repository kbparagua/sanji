class Sanji::Recipes::AdminNamespace < Sanji::Recipe

  def confirm
    'Create admin namespace for controllers?'
  end

  def after_bundle
    a.generate 'controller', 'admin/base'

    # Delete base folder created by generate
    a.inside 'app/views/admin' do
      a.run 'rm -R base'
    end

    self.add_route
  end

  def after_everything
    if a.yes? 'Create admin layout?'
      self.create_layout

      a.insert_into_file 'app/controllers/admin/base_controller.rb',
        "\tlayout 'admin'\n",
        :after => /ApplicationController\n/
    end
  end


  protected

  def add_route
    route = "namespace :admin do\n"
    route << "\tend\n"

    a.route route
  end

  def create_layout
    a.inside 'app/views/layouts' do
      a.run 'cp application.html.haml admin.html.haml'
    end

    a.insert_into_file(
      'app/views/layouts/admin.html.haml',
      '.admin',
      :after => '%body'
    )
  end

end
