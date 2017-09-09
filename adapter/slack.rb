require 'dotenv'
require_relative './adapter'
require 'json'



class Slack < Adapter

  def initialize
    super
    @endpoint = ENV["SLACK_INCOMING_WEBHOOK"]
  end

  def decode params
    synapse.message = params["text"]
    synapse
  end

  def encode synapse
    "payload=" + JSON.dump(
      {
        'text': synapse.response,
      }
    )
  end

end
