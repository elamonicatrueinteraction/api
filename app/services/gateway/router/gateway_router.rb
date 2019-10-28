module Gateway
  module Router
    class GatewayRouter

      def initialize(gateway_provider: Gateway::Provider.new)
        @gateway_provider = gateway_provider
      end

      def route_gateway(payment:, payment_type:, network_id:)
        payable_type = payment.payable.type
        route_gateway_for(payable_type: payable_type, payment_type: payment_type, network_id: network_id)
      end

      def route_gateway_for(payable_type:, payment_type:, network_id:)
        supplier = routes.select { |k, v| k.evaluate(payable_type: payable_type,
                                                    network: network_id, payment_type: payment_type) }.first&.dig(1)
        if supplier.nil?
          raise StandardError.new("[GatewayRouter] - No se encontró proveedor para el tipo #{payable_type}, red #{network_id} y tipo de pago #{payment_type}")
        end

        supplier.call
      end

      def routes
        {
          RouterRule.new(payable_type: "Order", networks: [:ROS], payment_types: default_payment_types) =>
            -> { @gateway_provider.gateway_for(service: :Mercadopago, payee_code: :ROS) },
          RouterRule.new(payable_type: "Order", networks: [:MDQ], payment_types: default_payment_types) =>
            -> { @gateway_provider.gateway_for(service: :Mercadopago, payee_code: :MDQ) },
          RouterRule.new(payable_type: "Order", networks: [:MCBA, :LP], payment_types: default_payment_types) =>
            -> { @gateway_provider.gateway_for(service: :Mercadopago, payee_code: :NILUS) },
          RouterRule.new(payable_type: "Delivery", networks: [:ROS, :MDQ, :MCBA, :LP], payment_types: default_payment_types) =>
            -> { @gateway_provider.gateway_for(service: :Mercadopago, payee_code: :NILUS) }
        }
      end

      def default_payment_types
        [Payment::PaymentTypes::PAGOFACIL, Payment::PaymentTypes::RAPIPAGO]
      end
    end
  end
end