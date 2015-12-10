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
        :after => /ApplicationController\n/ do
          a.text { |t| t.indent.puts "layout 'admin'" }
        end
    end
  end


  protected

  def add_route
    route =
      a.text do |t|
        t.puts 'namespace :admin do'
        t.indent.puts 'end'
      end

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
