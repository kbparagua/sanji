class Sanji::Recipes::Cleanup < Sanji::Recipe

  def after_everything
    # remove all helper comments from Setup recipe.
    a.gsub_file 'config/application.rb', /^\s*# sanji.*\n/, ''
  end

end
