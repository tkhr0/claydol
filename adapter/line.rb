require 'dotenv'
require_relative './adapter'
require 'faraday'

Dotenv.load ".env"

class Line < Adapter
  @@channel_access_token = ENV["CHANNEL_ACCESS_TOKEN"]

  def initialize hash
    super hash
    @endpoint = 'https://api.line.me/v2/bot/message/reply'
    append_require_env 'HTTP_X_LINE_SIGNATURE'
  end

  def decode params
    synapse.message = params['events'][0]['message']['text']
    synapse.token = params['events'][0]['replyToken']
    synapse
  end

  def encode synapse
    # FIXME: ヘッダの追加は別の場所でやりたい
    header = {
      "Content-Type": 'application/json',
      "Authorization": "Bearer #{@@channel_access_token}"
    }
    add_header header

    JSON.dump({
      replyToken: synapse.token,
      messages: [
        {
          type: "text",
          text: synapse.response
        }
      ]
    })
  end

  def filter rack_env
    ((/^LineBotWebhook/ =~ rack_env['HTTP_USER_AGENT']) != nil) \
     && (rack_env['HTTP_X_LINE_SIGNATURE'])
  end

end
