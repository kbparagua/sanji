class Sanji::Recipes::Seedbank < Sanji::Recipe

  def after_create
    a.add_gem 'seedbank'

    [:development, :staging, :production].each do |env|
      a.create_file "db/seeds/#{env}/main.seeds.rb",
        "# rake db:seed:#{env}:main"
    end
  end

end
