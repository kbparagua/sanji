class Sanji::Recipe

  attr_reader :a

  def initialize builder
    @a = Sanji::Assistant.new self, builder
    @disabled = false
  end

  def optional?
    Sanji::Options.instance.optional? self.class
  end

  def run_after_create
    @disabled = !self.confirm? if self.optional?
    return if @disabled

    a.log_start :after_create
    self.after_create
    a.log_end :after_create
  end

  def run_after_bundle
    return if @disabled

    a.log_start :after_bundle
    self.after_bundle
    a.log_end :after_bundle
  end

  def run_after_everything
    return if @disabled

    a.log_start :after_everything
    self.after_everything
    a.log_end :after_everything
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
