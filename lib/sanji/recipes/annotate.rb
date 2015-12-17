class Sanji::Recipes::Annotate < Sanji::Recipe

  def after_create
    a.gem 'annotate'
  end

  def after_bundle
    a.generate 'annotate:install'
  end

end
