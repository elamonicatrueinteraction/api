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
          mercadopago_data = Gateway::Mercadopago::PaymentMercadopagoSync::MercadopagoPaymentCheck.call(payment).result
          status = mercadopago_data[:status]
          if status != nil
            update_payment(payment, mercadopago_data) if payment.status != status
          else
            notify(payment)
          end
        end

        def update_payment(payment, mercadopago_data)
          Gateway::Mercadopago::PaymentMercadopagoSync::UpdatePayment.call(payment, mercadopago_data)
        end

        def notify(payment)
        #   Deberia de notificar que no existe este payment en mercadopago
        end

      end
    end
  end
end