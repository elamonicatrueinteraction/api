require 'mercadopago'

module Gateway
  module Mercadopago
    class MercadopagoGateway

      attr_accessor :client

      def initialize(access_token)
        @client = MercadoPago.new(access_token)
      end

      def create_payment(payload)
        @client.post("/v1/payments", payload)
      end

      def payment(id)
        @client.get_payment(id)
      end

      def cancel_payment(id)
        @client.cancel_payment(id)
      end
    end
  end
end