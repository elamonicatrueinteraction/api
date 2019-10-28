module Gateway
  module Router
    class RouterRule
      attr_reader :payable_type, :networks, :payment_types

      def initialize(payable_type:, networks: ,payment_types: )
        @payable_type = payable_type
        @networks = networks
        @payment_types = payment_types
      end

      def evaluate(payable_type:, network:, payment_type:)
        @payable_type == payable_type && @networks.include?(network.to_sym) && @payment_types.include?(payment_type)
      end
    end
  end
end