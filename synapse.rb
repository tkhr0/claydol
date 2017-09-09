class Synapse
  attr_accessor :adapter

  def initialize synapse=nil
    @data = {}

    unless synapse.nil?
      trace synapse
    end
  end

  def message= text
    @data[:message] = text
  end

  def message
    @data[:message]
  end

  def response= text
    @data[:response] = text
  end

  def response
    @data[:response]
  end

  def token= token
    @data[:token] = token
  end

  def token
    @data[:token]
  end

  private

  def trace synapse
    self.message = synapse.message
    self.response = synapse.response
  end
end
