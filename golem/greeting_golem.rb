class GreetingGolem < Golem
  def think synapse
    'hello world'
  end

  def trigger
    Regexp.new '^hoge.*'
  end
end
