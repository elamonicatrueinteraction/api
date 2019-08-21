require 'mercadopago'

module Gateway
  module Mercadopago
    class MercadopagoGateway

      attr_accessor :client

      def initialize(access_token)
        @client = MercadoPago.new(access_token)
      end

      def create_payment(payload)
        res = @client.post("/v1/payments", payload)
        Data.new(res)
      end

      def payment(id)
        res = @client.get_payment(id)
        Data.new(res)
      end

      def cancel_payment(id)
        res = @client.cancel_payment(id)
        Data.new(res)
      end
    end
  end
end