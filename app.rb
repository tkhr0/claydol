# coding: utf-8

require 'rack'
require 'rack/request'
require 'rack/response'
require 'rack/query_parser'

require 'pry'

class App
  def call(env)

    req = Rack::Request.new env
    query_parser = Rack::QueryParser.make_default 10, 10

    p query_parser.parse_nested_query req.query_string

    res = Rack::Response.new { |r|
      r.status = 200
    }

    res.finish
  end
end
