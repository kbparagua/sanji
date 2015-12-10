class Sanji::Recipes::Readme < Sanji::Recipe

  def after_create
    a.run 'rm README.rdoc'
    a.template 'README.md.erb', 'README.md'
  end

end
