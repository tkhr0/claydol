require './synapse'
require './golem/golem'
require 'digest/md5'
require_relative './model/receive_model'
require_relative './model/send_model'

class Gatekeeper
  @@golems = []
  @@adapters = []

  def initialize
    @receive_model = ReceiveModel.new
    @send_model = SendModel.new
  end

  def golems
    @@golems
  end

  def adapters
    @@adapters
  end

  def self.load_golems
    Dir.glob('./golem/*.rb').each do |golem|
      next if golem == './golem/golem.rb'
      require_relative golem
    end

    @@golems = Golem.golems.map { |golem_class|
      golem_class.new
    }
  end

  def self.load_adapters
    pathes = []
    Dir.glob('./adapter/*.rb').each do |adapter|
      next if adapter == './adapter/adapter.rb'
      require_relative adapter
      pathes.push adapter
    end

    @@adapters.concat Adapter.adapters.map.with_index { |adapter_class, idx|
      adapter = adapter_class.new Digest::MD5.hexdigest(pathes[idx])  # for response
      adapter
    }
  end

  def perform_distribute
    id = @receive_model.pop
    if id.nil?
      return
    end

    synapse = @receive_model.get id
    if synapse.nil?
      return
    end

    distribute(synapse).map { |res_synapse|
      id = @send_model.set res_synapse
      @send_model.push id
    }
  end

  def perform_send
    p "perform_send"

    id = @send_model.pop
    if id.nil?
      return
    end

    res_synapse = @send_model.get id
    talk res_synapse
  end

  def listen env, params
    @@adapters.each do |adapter|
      if adapter.filter extruct_env(env, adapter.require_envs)
        id = @receive_model.set adapter.listen(params)
        @receive_model.push id
      end
    end
  end

  def talk synapse
    @@adapters.each do |adapter|
      if adapter.hash == synapse.adapter
        adapter.talk synapse
        break
      end
    end
  end

  # deliver synapse to golem
  def distribute synapse
    responses = []

    @@golems.each do |golem|
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
