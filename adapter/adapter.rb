require 'faraday'
require_relative '../synapse'

class Adapter
  attr_accessor :endpoint

  @synapse = nil
  @@request_options = {
    headers: {},
    body: "",
  }

  # send message to chat client
  def talk synapse
    set_body encode synapse
    request
  end

  # receive message from chat client
  def listen params
    decode params
  end

  def filter
    true
  end

  def self.inherited concrete_adapter_class
    adapters << concrete_adapter_class
  end

  def self.adapters
    @@_adapters ||= []
  end

  private

  # decode request body to synapse
  def decode data
  end

  # encode synapse to request body
  def encode synapse
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
    @synapse = Synapse.new if @synapse.nil?
    @synapse
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
