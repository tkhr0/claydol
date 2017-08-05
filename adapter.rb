require 'faraday'
require './synapse'

class Adapter
  attr_accessor :endpoint

  @@synapse = nil
  @@request_options = {
    headers: {},
    body: "",
  }

  # send message to chat client
  def talk
    set_body encode
    request
  end

  # receive message from chat client
  def listen params
    decode params
  end

  private

  # decode request body to synapse
  def decode data
  end

  # encode synapse to request body
  def encode
  end

  # add request header to talk
  def add_header header
    @@request_options[:headers].merge header
  end

  # set request body to talk
  def set_body body
    @@request_options[:body] = body
  end

  # get synapse for this response
  def synapse
    @@synapse = Synapse.new if @@synapse.nil?
    @@synapse
  end

  # get connection for request
  def connection
    Faraday.new url: @endpoint do |builder|
      builder.use Faraday::Request::UrlEncoded  # リクエストパラメータを URL エンコードする
      builder.use Faraday::Response::Logger     # リクエストを標準出力に出力する
      builder.use Faraday::Adapter::NetHttp     # Net/HTTP をアダプターに使う
    end
  end

  # send request
  def request
    connection.post @endpoint,
      @@request_options[:body],
      @@request_options[:headers]
  end
end
