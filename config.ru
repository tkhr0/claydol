# conding: utf-8

require 'rack/parser'
require './claydol.rb'

use Rack::Reloader, 3
use Rack::Lint
use Rack::Parser

run Claydol.new
