class Sanji::Recipes::Haml < Sanji::Recipe

  def after_create
    a.add_gem 'haml-rails'
  end

  def after_everything
    a.rake 'haml:erb2haml'
  end

end
