class Synapse

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

  private

  def trace synapse
    self.message = synapse.message
    self.response = synapse.response
  end
end
