require 'sidekiq'
require_relative '../gatekeeper'

Sidekiq.configure_client do |config|
  config.redis = {
    url: "redis://redis:6379/12",
    namespace: 'send',
    size: 1,
  }
end

Sidekiq.configure_server do |config|
  config.redis = {
    url: "redis://redis:6379/12",
    namespace: 'send',
  }
end

class SendWorker
  include Sidekiq::Worker

  def initialize
    Gatekeeper.load_golems
    @gatekeeper = Gatekeeper.new
  end

  def perform
    @gatekeeper.perform_send
  end
end

