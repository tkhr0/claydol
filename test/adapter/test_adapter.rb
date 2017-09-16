require 'minitest/autorun'

require_relative '../../adapter/adapter'
require_relative '../../synapse'

class InheritedAdapter < Adapter
end

class TestAdapter < Minitest::Test
  def setup
    @hash = 'HASH'
    @adapter = Adapter.new @hash
  end

  def test_talk
    synapse = Minitest::Mock.new
      .expect(:response, 'response')

    @adapter.stub :request, true do
      @adapter.talk(synapse)
    end

    synapse.verify

  end

  def test_listen
    params = 'PARAMS'

    synapse = Minitest::Mock.new
      .expect(:message=, params, [String])
      .expect(:adapter=, hash, [String])


    @adapter.stub :synapse, synapse do
      assert_mock @adapter.listen(params)
      assert_kind_of String, @adapter.hash
    end

    synapse.verify
  end

  def test_filter
    assert_nil @adapter.filter([])
  end

  def test_self_inherited
    assert_equal true, (0 < Adapter.adapters.length)
  end

end
