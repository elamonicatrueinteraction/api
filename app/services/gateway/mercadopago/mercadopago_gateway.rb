module Gateway
  module Mercadopago
    class MercadopagoGateway

      def initialize(payee_code: )
        @tokens = Tenant::MeliCredentials.new
        @payee_code = payee_code
      end

      def payment(gateway_id:)
        client.payment(gateway_id)
      end

      def cancel_payment(gateway_id:)
        client.cancel_payment(gateway_id)
      end

      def paid?(gateway_id:)
        client.paid?(gateway_id)
      end

      def payee
        @tokens.credentials_for(network: @payee_code).slice(:payee_name, :email)
      end

      def create_payment(payment: , payment_type:)
        credentials = @tokens.credentials_for(network: @payee_code)
        Gateway::Mercadopago::CreatePayment.new(credentials: credentials)
          .create(payment: payment, payment_type: payment_type, description: payment_description(payment))
      end

      private

      def client
        credentials = @tokens.credentials_for(network: @payee_code)
        Gateway::Mercadopago::MercadopagoClient.new(credentials[:access_token])
      end

      def payment_description(payment)
        if payment.payable.is_type?("Order")
          "Order para '#{payment.payable&.receiver&.name}' - #{payment.payable.id}"
        else
          "Entrega para '#{payment.payable&.receiver&.name}' - #{payment.payable.id}"
        end
      end
    end
  end
end