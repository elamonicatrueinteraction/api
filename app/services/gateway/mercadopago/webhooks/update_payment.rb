module Gateway
  module Mercadopago
    module Webhooks
      class UpdatePayment
        prepend Service::Base

        def initialize(payment, gateway_id, notification_body = {})
          @payment = payment
          @gateway_id = gateway_id
          @notification_body = notification_body
          @account = PaymentGateway.account_for(@payment.payable)
        end

        def call
          update_payment
        end

        private

        def update_payment
          gateway_data = @account.payment(@gateway_id)
          return @payment if @payment.status == gateway_data.status

          @payment.status = gateway_data.status
          if gateway_data.status == Payment::Types::APPROVED
            collected_amount = gateway_data.total_paid_amount
            @payment.collected_amount = collected_amount
            @payment.paid_at = gateway_data.paid_at
          end
          if @payment.save
            # UpdateTotalDebtWorker.perform_async(@payment.id)
            @payment
          else
            errors.add_multiple_errors(@payment.errors.messages) && nil
          end
        end
      end
    end
  end
end
