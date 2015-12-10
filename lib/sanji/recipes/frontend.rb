class Sanji::Recipes::Frontend < Sanji::Recipe

  def after_create
    self.application_css_to_scss
    self.delete_application_scss_contents

    if self.use_bootstrap?
      self.setup_bootstrap
    else
      self.setup_normalize
    end
  end

  protected

  def application_css_to_scss
    a.inside 'app/assets/stylesheets' do
      a.run 'mv application.css application.scss'
    end
  end

  def delete_application_scss_contents
    a.gsub_file 'app/assets/stylesheets/application.scss', /(\S|\s)*/, ''
  end

  def use_bootstrap?
    a.yes? 'Use twitter bootstrap css and javascripts?'
  end

  def setup_bootstrap
    a.add_gem 'bootstrap-sass'

    a.append_to_file 'app/assets/stylesheets/application.scss' do
      "@import 'bootstrap-sprockets';\n" \
      "@import 'bootstrap';\n"
    end

    a.insert_into_file 'app/assets/javascripts/application.js',
      "//= require bootstrap-sprockets\n",
      :after => "//= require jquery\n"
  end

  def setup_normalize
    a.add_gem 'normalize-rails'

    a.append_to_file 'app/assets/stylesheets/application.scss' do
      "@import 'normalize-rails';\n"
    end
  end

end
