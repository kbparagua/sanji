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
    Sanji::Config::Main.instance.preferred_cookbook.optional? self.class.name
  end

  def run_after_create
    # Need to set this because we need to display recipe name
    # when asking user to confirm.
    a.active_recipe = self

    @disabled = !self.confirm? if self.optional?

    if @disabled
      a.active_recipe = nil
      return
    end

    self.run :after_create
  end

  def run_after_bundle
    return if @disabled
    self.run :after_bundle
  end

  def run_after_everything
    return if @disabled
    self.run :after_everything
  end

  def confirm?
    if self.description.present?
      a.say "Description: #{self.description}"
    end

    a.yes? 'Do you want to run this recipe?'
  end

  def description
  end

  protected

  def run callback_name = ''
    return unless self.respond_to? callback_name

    a.active_recipe = self

    a.log_start callback_name
    self.send callback_name
    a.log_end callback_name

    a.active_recipe = nil
  end


end
