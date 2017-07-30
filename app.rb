# coding: utf-8

require 'rack'
require 'rack/request'
require 'rack/response'
require 'rack/query_parser'
require 'json'
require 'faraday'
require 'dotenv'

require 'pry'

Dotenv.load ".env"

class App
  @@channel_access_token = ENV["CHANNEL_ACCESS_TOKEN"]

  def call(env)
    p env["HTTP_X_LINE_SIGNATURE"]
    p @@channel_access_token

    req = Rack::Request.new env

    if req.post?
      line_request = JSON.parse(req.body.read)
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
    elsif req.get?
      query_parser = Rack::QueryParser.make_default 10, 10
      p query_parser.parse_nested_query req.query_string
    end


    res = Rack::Response.new { |r|
      r.status = 200
    }
    res.finish

  end
end

