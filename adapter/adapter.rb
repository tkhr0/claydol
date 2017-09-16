require 'faraday'
require_relative '../synapse'

class Adapter
  attr_accessor :endpoint
  attr_reader :require_envs
  attr_accessor :hash

  def initialize hash
    @synapse = nil
    @request_options = {
      headers: {},
      body: "",
    }
    @require_envs = [
      'HTTP_USER_AGENT',
    ]
    self.hash = hash
  end

  # send message to chat client
  def talk synapse
    set_body encode synapse
    request
  end

  # receive message from chat client
  def listen params
    synapse = decode params
    synapse.adapter = hash
    synapse
  end

  # return true if it can deal request.
  def filter rack_env
  end

  def self.inherited concrete_adapter_class
    adapters << concrete_adapter_class
  end

  private

    def self.adapters
      @@_adapters ||= []
    end

    # decode request body to synapse
    def decode data
      synapse.message = data
      synapse
    end

    # encode synapse to request body
    def encode synapse
      synapse.response
    end

    # add request header to talk
    def add_header header
      @request_options[:headers].update header
    end

    # set request body to talk
    def set_body body
      @request_options[:body] = body
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
        @request_options[:body],
        @request_options[:headers]
    end

    def append_require_env env
      @require_envs.push env
    end

end
