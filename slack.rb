require 'dotenv'
require './adapter'
require 'json'

Dotenv.load '.env'


class Slack < Adapter

  def initialize
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
