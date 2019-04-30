module Gateway
  module Mercadopago
    module PaymentMercadopagoSync
      class FakePaymentsCheck
        prepend Service::Base

        def initialize(status_expect)
          @status = status_expect
        end

        def call
          check
        end

        private

        def check
          pending_payments = Gateway::Mercadopago::PaymentMercadopagoSync::PendingPayments.call.result

          pending_payments.each(&method(:mercadopago_check))
        end

        def mercadopago_check(payment)
          mercadopago_data = Gateway::Mercadopago::PaymentMercadopagoSync::FakeMercadopagoPaymentCheck.call(payment, state(payment.id)).result
          update_payment(payment, mercadopago_data) if payment.status != mercadopago_data['status']
        end

        def update_payment(payment, mercadopago_data)
          Gateway::Mercadopago::PaymentMercadopagoSync::UpdatePayment.call(payment, mercadopago_data)
        end

        def state(key)
          @status[key]
        end

      end
    end
  end
end

