require 'mercadopago'

module Gateway
  module Mercadopago
    class MercadopagoClient

      attr_accessor :client

      def initialize(access_token)
        @client = MercadoPago.new(access_token)
      end

      def create_payment(payload)
        res = @client.post("/v1/payments", payload)
        res = eval(res) if res.is_a?(String)
        Mercadopago::Data.new(res)
      end

      def payment(id)
        res = @client.get_payment(id)
        res = eval(res) if res.is_a?(String)
        Mercadopago::Data.new(res)
      end

      def cancelled?(id)
        @client.get_payment(id)["response"]["status"] == "cancelled"
      end

      def paid?(id)
        @client.get_payment(id)["response"]["status"] == "approved"
      end

      def cancel_payment(id)
        res = @client.cancel_payment(id)
        res = eval(res) if res.is_a?(String)
        Mercadopago::Data.new(res)
      end
    end
  end
end