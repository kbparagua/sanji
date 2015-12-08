class Sanji::Recipes::Annotate < Sanji::Recipe

  def after_create
    builder.gem 'annotate'
  end

  def after_bundle
    builder.generate 'annotate:install'
  end

end
