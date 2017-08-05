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
  end

  def encode
    "payload=" + JSON.dump(
      {
        'text': synapse.message,
      }
    )
  end

end
