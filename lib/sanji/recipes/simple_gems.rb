class Sanji::Recipes::SimpleGems < Sanji::Recipe

  def after_create
    [:paperclip, :kaminari].each { |name| a.add_gem name }

    [:thin, :quiet_assets].each do |name|
      a.add_gem name, :group => [:development, :test]
    end
  end

end
