module Gateway
  module Mercadopago
    module PaymentMercadopagoSync
      class FakeMercadopagoPaymentCheck
        prepend Service::Base

        def initialize(payment, state)
          @payment = payment
          @state = state
        end

        def call
          get_payment_mercadopago
        end

        private

        def get_payment_mercadopago
          data = @payment.gateway_data
          data['status'] = @state
          data['status_detail'] = "State_#{@state}"
          data['date_approved'] = Time.zone.now if @state == "approved"
          data
        end
      end
    end
  end
end