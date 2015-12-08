class Sanji::Recipes::Devise < Sanji::Recipe

  def after_create
    a.add_gem 'devise', '~> 3.0.0'
  end

  def after_bundle
    a.generate 'devise:install'
    a.generate 'devise:views'
    a.generate 'devise User'

    a.rake 'db:migrate'
  end

end
