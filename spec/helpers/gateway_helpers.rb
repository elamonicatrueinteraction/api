module GatewayHelpers
  class FakePaymentGateway
    def initialize(account)
      @account = account
    end

    def account_for(something)
      @account
    end
  end

  class AlwaysPaidGateway

    def initialize
      @times_called = 0
    end

    def paid?(payable)
      @times_called += 1
      true
    end

    def times_called
      @times_called
    end
  end
end