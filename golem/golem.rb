class Golem

  def think synapse
    synapse
  end

  def trigger
    # return Regexp
  end

  def understand? text
  end

  def self.inherited concrete_golem_class
    golems << concrete_golem_class
  end

  def self.golems
    @@_golems ||= []
  end
end
