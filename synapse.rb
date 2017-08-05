class Synapse

  def initialize
    @data = {}
  end

  def message= text
    @data[:message] = text
  end

  def message
    @data[:message]
  end

end
