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
    gatekeeper.load_adapters
    gatekeeper.load_golems

    if req.post?
      params = req.params
      params.freeze
      gatekeeper.listen params

    elsif req.get?
      query_parser = Rack::QueryParser.make_default 10, 10
      p query_parser.parse_nested_query req.query_string
    end

    gatekeeper.main

    res = Rack::Response.new { |r|
      r.status = 200
    }
    res.finish

  end
end

