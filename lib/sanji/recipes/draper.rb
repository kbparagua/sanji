class Sanji::Recipes::Draper < Sanji::Recipe

  def after_create
    builder.gem 'draper'

    self.generator :decorator, false
  end

  def after_bundle
    builder.create_file 'app/decorators/application_decorator.rb' do
      "class ApplicationDecorator < Draper::Decorator\nend"
    end
  end

end
