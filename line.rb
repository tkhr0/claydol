require 'dotenv'
require 'faraday'

Dotenv.load ".env"

class Line
  @@channel_access_token = ENV["CHANNEL_ACCESS_TOKEN"]

  def response req
    line_request = req
    p line_request
    line_request["events"].each do |event|

      message = event["message"]

      p message
      conn = Faraday.new url: 'https://api.line.me/v2/bot/message/reply' do |builder|
        builder.use Faraday::Request::UrlEncoded  # リクエストパラメータを URL エンコードする
        builder.use Faraday::Response::Logger     # リクエストを標準出力に出力する
        builder.use Faraday::Adapter::NetHttp     # Net/HTTP をアダプターに使う
      end

      line_res = conn.post do |line_req|
        line_req.headers["Content-Type"] = 'application/json'
        line_req.headers["Authorization"] = "Bearer #{@@channel_access_token}"

        line_req.body = JSON.dump({
          replyToken: event["replyToken"],
          messages: [
            {type: "text", text: message['text']}
          ]
        })
        p line_req
      end

      p line_res
    end
  end

end
