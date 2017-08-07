# coding: utf-8

require 'rack'
require 'rack/request'
require 'rack/response'
require 'rack/query_parser'
require 'json'
require 'faraday'
require 'dotenv'
require './gatekeeper'

require 'pry'

Dotenv.load ".env"


class App

  def call(env)
    p ENV

    req = Rack::Request.new env

    p req
    p req.params

    gatekeeper = Gatekeeper.new
    gatekeeper.load_golems

    if req.post?


      # line.response req.params
      synapse = slack.listen req.params
      # slack.talk

      responses = gatekeeper.distribute synapse

      responses.each do |synapse|
        slack.talk synapse
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

