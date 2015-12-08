class Sanji::Recipes::Setup < Sanji::Recipe

  def after_create
    a.insert_into_file 'config/application.rb',
      :after => "class Application < Rails::Application\n" do

        a.text do |t|
          t.indent(2).puts 'config.generators do |g|'
          t.indent(3).puts '# sanji-generators'
          t.indent(2).puts 'end'
        end
      end
  end


  protected

end
