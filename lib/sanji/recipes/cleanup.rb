class Sanji::Recipes::Cleanup < Sanji::Recipe

  def after_everything
    # remove all helper comments from Setup recipe.
    [
      'config/application.rb',
      'Gemfile'
    ].each { |file| a.gsub_file file, /^\s*# sanji.*\n/, '' }
  end

end
