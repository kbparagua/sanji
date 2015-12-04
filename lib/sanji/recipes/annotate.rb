class Sanji::Recipes::Annotate < Sanji::Recipes::Base

  def after_create
    super
    builder.gem 'annotate'
  end

  def after_bundle
    super
    builder.generate 'annotate:install'
  end

end
