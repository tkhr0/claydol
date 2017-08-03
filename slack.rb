require 'dotenv'
require 'faraday'

Dotenv.load ".env"

class Slack
  @@slack_incoming_webhook = ENV["SLACK_INCOMING_WEBHOOK"]

  def response req
    conn = Faraday.new url: @@slack_incoming_webhook do |builder|
      builder.use Faraday::Request::UrlEncoded  # リクエストパラメータを URL エンコードする
      builder.use Faraday::Response::Logger     # リクエストを標準出力に出力する
      builder.use Faraday::Adapter::NetHttp     # Net/HTTP をアダプターに使う
    end

    slack_res = conn.post do |res|
      res.body = "payload=" + JSON.dump({
        text: 'foo'
      })
    end

    p slack_res
  end
end
