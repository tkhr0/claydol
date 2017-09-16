class GreetingGolem < Golem
  def think synapse
    synapse.response = 'hello world'
    return synapse
  end

  def trigger
    Regexp.new '^hoge.*'
  end

  def understand? text
    /^hoge.*/ === text
  end
end
