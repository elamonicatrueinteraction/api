module Gateway
  module Mercadopago
    module PaymentMercadopagoSync
      class MercadopagoPaymentCheck
        prepend Service::Base

        def initialize(payment)
          @gateway_id = payment.gateway_id #gateway_id es el id de como lo guardo mercadopago
          @account = PaymentGateway.account_for(payment.payable) #payable es la order => con la order consigue la cuenta de mercadopago
        end

        def call
          get_payment_mercadopago
        end

        private

        def get_payment_mercadopago
          @account.payment(@gateway_id)
        end
      end
    end
  end
end