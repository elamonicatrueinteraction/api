module Gateway
  module Mercadopago
    module PaymentMercadopagoSync
      class PendingPayments
        prepend Service::Base

        def call
          get_pending_payments
        end

        private

        def get_pending_payments
          Payment.select{|x| x.status == "pending"}
        end
      end
    end
  end
end