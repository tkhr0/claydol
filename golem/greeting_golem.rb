class GreetingGolem < Golem
  def think synapse
    # FIXME: return Synapse
    'hello world'
  end

  def trigger
    Regexp.new '^hoge.*'
  end
end
