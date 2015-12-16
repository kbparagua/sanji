class Sanji::Recipes::Draper < Sanji::Recipe

  def description
    'Decorator for views'
  end

  def after_create
    a.gem 'draper'
    a.generator :decorator, false
  end

  def after_bundle
    a.create_file 'app/decorators/application_decorator.rb' do
      "class ApplicationDecorator < Draper::Decorator\nend"
    end
  end

end
