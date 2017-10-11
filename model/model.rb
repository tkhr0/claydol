require 'redis'
require_relative '../synapse'

class Model
  def initialize root
    @redis = Redis.new url: "redis://redis:6379/12"
    @root = root
  end

  #
  # Synapse を保存する
  #
  # return: id
  #
  def set synapse
    id = next_id @root
    set_synapse "#{@root}:#{id}", synapse
    id
  end

  #
  # Synapse を取得
  #
  # return: Synapse
  #
  def get id
    get_synapse "#{@root}:#{id}"
  end

  #
  # キューに追加
  #
  def push value
    push_by @root, value
  end

  #
  #キューから取得
  #
  def pop
    pop_by @root
  end


  private

  #
  # type の次の ID を取得する
  #
  def next_id type
    @redis.incr "global:nextId:#{type}"
  end

  #
  # Synapse を key に保存する
  def set_synapse key, synapse
    @redis.hmset key, *(synapse.to_kv_array)
  end

  #
  # key の value を Syanapse に変換して取得する
  #
  def get_synapse key
    row_hash = @redis.hgetall key
    create_synapse row_hash
  end

  #
  # Synapseを作成する
  # Synapseに対応したhashから
  #
  def create_synapse hash
    # TODO: hash から new
    synapse = Synapse.new
    synapse.from_hash hash
    synapse
  end

  #
  # キューに追加する
  # typeに分類する
  #
  def push_by type, value
    @redis.rpush "queue:#{type}", value
  end

  #
  # typeのキューから取得する
  #
  def pop_by type
    @redis.lpop "queue:#{type}"
  end
end
