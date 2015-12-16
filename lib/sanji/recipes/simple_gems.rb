class Sanji::Recipes::SimpleGems < Sanji::Recipe

  def after_create
    ['paperclip', 'kaminari'].each { |name| a.gem name }

    ['thin', 'quiet_assets'].each do |name|
      a.gem name, :group => [:development, :test]
    end
  end

end
