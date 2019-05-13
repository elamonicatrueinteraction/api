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
          Sidekiq::logger.info 'Request all pending payments'

          pending_payments = Gateway::Mercadopago::PaymentMercadopagoSync::PendingPayments.call.result

          pending_payments.each(&method(:mercadopago_check))
        end

        def mercadopago_check(payment)
          Sidekiq::logger.info "Request to mercadopago about a payment with id: #{payment.id} and gateway_id: #{payment.gateway_id}"

          mercadopago_data = Gateway::Mercadopago::PaymentMercadopagoSync::MercadopagoPaymentCheck.call(payment).result
          status = mercadopago_data[:status]

          Sidekiq::logger.info "Response mercadopago status: #{status}"

          if status != nil
            update_payment(payment, mercadopago_data) if payment.status != status
          else
            notify(payment)
          end
        end

        def update_payment(payment, mercadopago_data)
          Sidekiq::logger.info 'In update payment'

          result = Gateway::Mercadopago::PaymentMercadopagoSync::UpdatePayment.call(payment, mercadopago_data)

          Sidekiq::logger.info "Result update: #{result.result}"
        end

        def notify(payment)
        #   Deberia de notificar que no existe este payment en mercadopago
        end

      end
    end
  end
end