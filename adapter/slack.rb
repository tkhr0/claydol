require 'dotenv'
require_relative './adapter'
require 'json'



class Slack < Adapter

  def initialize hash
    super hash
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

  def filter rack_env
    ((/^Slackbot/ =~ rack_env['HTTP_USER_AGENT']) != nil)
  end

end
