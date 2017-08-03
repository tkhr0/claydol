# conding: utf-8

require 'rack/parser'
require './app.rb'

use Rack::Reloader, 3
use Rack::Parser

run App.new
