Dir["#{File.dirname(__FILE__)}/recipes/*.rb"].each do |filename|
  require filename.sub(/\.rb\z/, '')
end

# Require user recipes
if Sanji::Config::Main.instance.user_recipes_path.present?
  Dir["#{Sanji::Config::Main.instance.user_recipes_path}/*.rb"].each do |filename|
    require filename.sub(/\.rb\z/, '')
  end
end
