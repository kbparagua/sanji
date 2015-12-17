class Sanji::Recipes::Postgresql < Sanji::Recipe

  def after_create
    a.remove_gem 'sqlite3'
    a.gem 'pg'

    self.create_database_yml
  end

  def after_bundle
    if a.yes?('Drop and create database?')
      a.rake 'db:drop'
      a.rake 'db:create'
    end
  end


  protected

  def create_database_yml
    username = a.ask 'Development database username?'
    password = a.ask 'Development database password?'

    a.delete_file 'config/database.yml'
    a.template 'database.yml.erb', 'config/database.yml',
      :username => username,
      :password => password
  end

end
