class Sanji::Recipes::Setup < Sanji::Recipe

  def after_create
    self.add_generators_block
  end


  protected

  def add_generators_block
    a.application_config do |t|
      t.indent(2).puts 'config.generators do |g|'
      t.indent(3).puts '# sanji-generators'
      t.indent(2).puts 'end'
    end
  end

end
