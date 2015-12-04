class Sanji::Recipes::Annotate < Sanji::Recipes::Base

  def after_create
    builder.gem 'annotate'
  end

  def after_bundle
    builder.generate 'annotate:install'
  end

  def after_everything

  end

end
