require 'sidekiq'
require_relative '../gatekeeper'

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://redis:6379/12", namespace: 'recieve', size: 1}
end

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://redis:6379/12", namespace: 'recieve' }
end

class RecieveWorker
  include Sidekiq::Worker

  def perform

  end
end
