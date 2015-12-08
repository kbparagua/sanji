class Sanji::Recipes::Annotate < Sanji::Recipe

  def after_create
    a.add_gem 'annotate'
  end

  def after_bundle
    a.generate 'annotate:install'
  end

end
