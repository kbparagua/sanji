Dir["#{File.dirname(__FILE__)}/config/*.rb"].each do |filename|
  require filename.sub(/\.rb\z/, '')
end
