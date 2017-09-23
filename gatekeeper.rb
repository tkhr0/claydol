require './synapse'
require './golem/golem'
require 'digest/md5'

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
    pathes = []
    Dir.glob('./adapter/*.rb').each do |adapter|
      next if adapter == './adapter/adapter.rb'
      require_relative adapter
      pathes.push adapter
    end

    @adapters.concat Adapter.adapters.map.with_index { |adapter_class, idx|
      adapter = adapter_class.new Digest::MD5.digest(pathes[idx])  # for response
      adapter
    }
  end

  def main
    while !@incoming_queue.empty?
      synapse = @incoming_queue.shift
      @outgoing_queue.concat distribute(synapse)
    end

    while !@outgoing_queue.empty?
      synapse = @outgoing_queue.shift
      talk synapse
    end
  end

  def listen env, params
    @adapters.each do |adapter|
      if adapter.filter extruct_env(env, adapter.require_envs)
        @incoming_queue << adapter.listen(params)
      end
    end
  end

  def talk synapse
    @adapters.each do |adapter|
      if adapter.hash.equal? synapse.adapter
        adapter.talk synapse
        break
      end
    end
  end

  # deliver synapse to golem
  def distribute synapse
    responses = []

    @golems.each do |golem|
      if golem.trigger.match synapse.message

        res_synapse = Synapse.new synapse
        res_synapse = golem.think synapse

        responses << res_synapse
      end
    end

    responses
  end

  private

    def extruct_env rack_env, require_envs
      rack_env.select { |env|
        require_envs.include? env
      }
    end
end
