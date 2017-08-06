require './synapse'
require './golem/golem'

class Gatekeeper
  def initialize
    @golems = []
  end

  def load_golems
    Dir.glob('./golem/*.rb').each do |golem|
      require_relative golem
    end
  end

  def distribute synapse
    responses = []

    Golem.golems.each do |golem|
      if golem.trigger.match synapse.message

        res_synapse = Synapse.new synapse
        res_synapse.response = golem.think synapse

        responses << res_synapse
      end
    end

    responses
  end
end
