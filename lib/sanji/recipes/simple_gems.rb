class Sanji::Recipes::SimpleGems < Sanji::Recipe

  def after_create
    ['paperclip', 'kaminari'].each { |name| a.gem name }

    a.gem_group :development, :test do
      gem 'thin'
    end

    a.gem_group :development, :test do
      gem 'quiet_assets'
    end
  end

end
