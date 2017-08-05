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
    {
      'text': synapse.message,
    }
  end

  def talk
    set_body "payload=" + JSON.dump(encode)
    super
  end
end
