class Sanji::Recipes::Setup < Sanji::Recipe

  def after_create
    self.add_generators_block
  end


  protected

  def add_generators_block
    config = "\t\tconfig.generators do |g|\n"
    config << "\t\t\t# sanji-generators\n"
    config << "\t\tend"

    a.application_config config
  end

end
