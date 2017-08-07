require './synapse'
require './golem/golem'

class Gatekeeper
  def initialize
    @golems = []
    @adapters = []

    @incoming_queue = []
    @outgoing_queue = []
  end

  def load_golems
    Dir.glob('./golem/*.rb').each do |golem|
      next if golem == './golem/golem.rb'
      require_relative golem
    end

    @golems = Golem.golems.map { |golem_class|
      golem_class.new
    }
  end

  def load_adapters
    Dir.glob('./adapter/*.rb').each do |adapter|
      next if adapter == './adapter/adapter.rb'
      require_relative adapter
    end

    @adapters = Adapter.adapters.map { |adapter_class|
      adapter_class.new
    }
  end

  def main
    @incoming_queue.each do |synapse|
      @outgoing_queue.concat distribute(synapse)
    end

    @outgoing_queue.each do |synapse|
      talk synapse
    end
  end

  def listen params
    @adapters.each do |adapter|
      if adapter.filter
        @incoming_queue << adapter.listen(params)
      end
    end
  end

  def talk synapse
    @adapters.each do |adapter|
      adapter.talk synapse
    end
  end

  # deliver synapse to golem
  def distribute synapse
    responses = []

    @golems.each do |golem|
      if golem.trigger.match synapse.message

        res_synapse = Synapse.new synapse
        res_synapse.response = golem.think synapse  # FIXME: return Synapse directoly

        responses << res_synapse
      end
    end

    responses
  end
end
