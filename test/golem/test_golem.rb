require 'minitest/autorun'

require_relative '../../golem/golem'
require_relative '../../synapse'

class InheritedGolem < Golem
end

class TestGolem < Minitest::Test
  def setup
    @golem = Golem.new
  end

  def test_think
    synapse = Synapse.new
    assert_kind_of Synapse, @golem.think(synapse)
  end

  def test_understand?
    assert_nil @golem.understand?('')
  end

  def test_self_inherited
    assert_equal true, (0 < Golem.golems.length)
  end

  def test_self_golems
    assert_kind_of Array, Golem.golems
  end
end
