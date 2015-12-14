class Sanji::Recipe

  attr_reader :a

  def self.instance
    @instance ||= self.new
  end



  def initialize
    @a = Sanji::Assistant.instance
    @disabled = false
  end

  def optional?
    Sanji::Options.instance.optional? self.class
  end

  def run_after_create
    a.active_recipe = self

    @disabled = !self.confirm? if self.optional?
    if @disabled
      a.active_recipe = nil
      return
    end

    a.log_start :after_create
    self.after_create
    a.log_end :after_create

    a.active_recipe = nil
  end

  def run_after_bundle
    return if @disabled

    a.active_recipe = self

    a.log_start :after_bundle
    self.after_bundle
    a.log_end :after_bundle

    a.active_recipe = nil
  end

  def run_after_everything
    return if @disabled

    a.active_recipe = self

    a.log_start :after_everything
    self.after_everything
    a.log_end :after_everything

    a.active_recipe = nil
  end

  def after_create
  end

  def after_bundle
  end

  def after_everything
  end

  def confirm?
    if self.description.present?
      a.say "Description: #{self.description}"
    end

    a.yes? 'Do you want to run this recipe?'
  end

  def description
  end

end
