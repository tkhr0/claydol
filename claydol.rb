# coding: utf-8

require 'rack'
require 'rack/request'
require 'rack/response'
require 'rack/query_parser'
require 'json'
require 'faraday'
require 'dotenv'
require_relative 'gatekeeper'
require_relative 'worker/distribute_worker'

require 'pry'

Dotenv.load ".env"


class Claydol

  def initialize
    Gatekeeper.load_adapters
    Gatekeeper.load_golems
    @gatekeeper = Gatekeeper.new
  end

  def call(env)
    # p ENV

    req = Rack::Request.new env

    # p req
    # p req.params


    if req.post?
      env = req.env.clone
      params = req.params.clone
      # data = {
      #   env: env,
      #   params: params
      # }

      @gatekeeper.listen env, params
      DistributeWorker.perform_async

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

