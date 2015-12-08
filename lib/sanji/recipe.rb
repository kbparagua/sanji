class Sanji::Recipe

  attr_reader :a

  def initialize builder
    @a = Sanji::Assistant.new self, builder
  end

  def run_after_create
    a.log_start :after_create
    self.after_create
    a.log_end :after_create
  end

  def run_after_bundle
    a.log_start :after_bundle
    self.after_bundle
    a.log_end :after_bundle
  end

  def run_after_everything
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

end
