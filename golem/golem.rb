class Golem
  def think text
  end

  def trigger
  end

  def self.inherited concrete_golem_class
    golems << concrete_golem_class.new
  end

  def self.golems
    @@_golems ||= []
  end
end
