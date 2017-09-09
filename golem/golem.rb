class Golem

  def think synapse
    #return synapse
  end

  def trigger
    # return Regexp
  end

  def self.inherited concrete_golem_class
    golems << concrete_golem_class
  end

  def self.golems
    @@_golems ||= []
  end
end
