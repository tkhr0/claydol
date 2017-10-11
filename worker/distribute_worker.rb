require 'sidekiq'
require_relative '../gatekeeper'
require_relative './send_worker'

require 'pry'

Sidekiq.configure_client do |config|
  config.redis = {
    url: "redis://redis:6379/12",
    namespace: 'distribute',
    size: 1,
  }
end

Sidekiq.configure_server do |config|
  config.redis = {
    url: "redis://redis:6379/12",
    namespace: 'distribute',
  }
end

class DistributeWorker
  include Sidekiq::Worker

  def initialize
    Gatekeeper.load_golems
    @gatekeeper = Gatekeeper.new
  end

  def perform
    @gatekeeper.perform_distribute
    SendWorker.perform_async
  end
end
