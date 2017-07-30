# conding: utf-8

use Rack::Reloader, 3

require './app.rb'

run App.new
