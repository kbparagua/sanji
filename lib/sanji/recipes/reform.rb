class Sanji::Recipes::Reform < Sanji::Recipe

  def after_create
    a.add_gem 'reform'
    a.add_gem 'virtus'
  end

  def after_bundle
    a.copy_file 'base_form.rb', 'app/forms/base_form.rb'
  end

end
