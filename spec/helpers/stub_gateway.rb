class StubGateway

  def initialize(id_response_data: )
    @id_response_data_hash = id_response_data
  end

  def payment(id)
    @id_response_data_hash[id]
  end
end