class Sanji::Recipes::Cleanup < Sanji::Recipe

  def after_everything
    # remove all helper comments from Setup recipe.
    [
      'config/application.rb',
      'Gemfile'
    ].each { |file| a.gsub_file file, /^\s*# sanji.*\n/, '' }

    self.remove_gemfile_comments
  end

  protected

  def remove_gemfile_comments
    a.gsub_file 'Gemfile', /^\s*#.*\n/, ''
  end

end
