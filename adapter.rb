require 'faraday'
require './synapse'

class Adapter
  attr_accessor :endpoint

  @@synapse = nil
  @@request_options = {
    headers: {},
    body: "",
  }

  def talk
    request
  end

  def listen params
    decode params
  end

  private

  def decode data
  end

  def encode
  end

  def add_header header
    @@request_options[:headers].merge header
  end

  def set_body body
    @@request_options[:body] = body
  end

  def synapse
    @@synapse = Synapse.new if @@synapse.nil?
    @@synapse
  end

  def connection
    Faraday.new url: @endpoint do |builder|
      builder.use Faraday::Request::UrlEncoded  # リクエストパラメータを URL エンコードする
      builder.use Faraday::Response::Logger     # リクエストを標準出力に出力する
      builder.use Faraday::Adapter::NetHttp     # Net/HTTP をアダプターに使う
    end
  end

  def request
    connection.post @endpoint, @@request_options[:body], @@request_options[:headers]
  end
end
