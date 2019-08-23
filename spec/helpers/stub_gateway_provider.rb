class StubGatewayProvider

  def initialize(gateway)
    @gateway = gateway
  end

  def account_for(_payable)
    @gateway
  end
end