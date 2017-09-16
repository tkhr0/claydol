require 'minitest/autorun'

require_relative '../../golem/greeting_golem'
require_relative '../../synapse'

class TestGreetingGolem < Minitest::Test
  def setup
    @greeting_golem = GreetingGolem.new
  end

  def test_think
    think = @greeting_golem.think Synapse.new

    assert_equal Synapse.new.class, think.class
    assert_equal 'hello world', think.response
  end

  def test_understand?
    assert_equal true,  @greeting_golem.understand?('hoge')
    assert_equal true,  @greeting_golem.understand?('hoge, hello')
    assert_equal false, @greeting_golem.understand?('hi, hoge')
  end
end
