module Gateway
  module Mercadopago
    module PaymentMercadopagoSync
      class PaymentsCheck
        prepend Service::Base

        def call
          check
        end

        private

        def check
          pending_payments = Gateway::Mercadopago::PaymentMercadopagoSync::PendingPayments.call.result

          pending_payments.each(&method(:mercadopago_check))
        end

        def mercadopago_check(payment)
          mercadopago_data = Gateway::Mercadopago::PaymentMercadopagoSync::MercadopagoPaymentCheck.call(payment)
          update_payment(payment, mercadopago_data) if payment.status != mercadopago_data.result['status']
        end

        def update_payment(payment, mercadopago_data)
          Gateway::Mercadopago::PaymentMercadopagoSync::UpdatePayment.call(payment, mercadopago_data)
        end

      end
    end
  end
end