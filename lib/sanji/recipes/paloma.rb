class Sanji::Recipes::Paloma < Sanji::Recipe

  def after_create
    a.add_gem 'paloma'

    a.insert_into_file 'app/assets/javascripts/application.js',
      "//= require paloma\n",
      :after => "//= require jquery_ujs\n"
  end

end
