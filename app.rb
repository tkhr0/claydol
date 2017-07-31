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
  @@slack_incoming_webhook = ENV["SLACK_INCOMING_WEBHOOK"]

  def call(env)
    p env["HTTP_X_LINE_SIGNATURE"]
    p @@channel_access_token

    req = Rack::Request.new env

    p req



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

