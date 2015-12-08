class Sanji::Recipes::Figaro < Sanji::Recipe

  def after_create
    a.add_gem 'figaro'

    self.create_application_yml_sample
  end

  def after_bundle
    a.bundle_exec 'figaro install'
  end

  protected

  def create_application_yml_sample
    a.create_file 'config/application.sample.yml' do
      "# This will be the template for application.yml\n" \
      "# Put all valid keys here and their sample values."
    end
  end

end
