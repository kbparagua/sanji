class Sanji::Config::BlankFile

  def cookbook
    nil
  end

  def has_cookbook? key_name
    false
  end

  def recipes_for cookbook_key_name
    []
  end

  def optional_recipes_for cookbook_key_name
    []
  end

  def recipes_path
    nil
  end

end
