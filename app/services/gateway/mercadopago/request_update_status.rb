module Gateway
  module Mercadopago
    class RequestUpdateStatus
      prepend Service::Base

      # Mercadopago no tiene ambiente de prueba para cambiar el status de un payment con metodo de pago ticket

      # def initialize(payment, status)
      #   @payment = payment
      #   @status = status
      #   @account = PaymentGateway.account_for(@payment.payable)
      # end
      #
      # def call
      #   update
      # end
      #
      # private
      #
      # def update
      #   @account.client.call(:payments, :update, {id: @payment.gateway_id, 'status': @status})
      # end
      #
      # def update_payment(payment_id, payload)
      #   payload = MultiJson.dump(payload)
      #   MercadoPago::Core::Request.put_request("/v1/payments/#{payment_id}?access_token=#{@access_token}", payload)
      # end
    end
  end
end