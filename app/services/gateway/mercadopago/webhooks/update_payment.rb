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
          new_gateway_data = @account.payment(@gateway_id).deep_symbolize_keys
          Rails.logger.info "Mercadopago request: #{new_gateway_data.inspect}"

          return @payment if @payment.status == new_gateway_data[:status]

          @payment.status = new_gateway_data[:status]
          @payment.collected_amount = new_gateway_data.dig(:transaction_details, :total_paid_amount)
          @payment.paid_at = Time.zone.now
          @payment.notifications = updated_notifications( new_gateway_data )

          return @payment if @payment.save

          errors.add_multiple_errors(@payment.errors.messages) && nil
        end

        def updated_notifications(new_gateway_data)
          (@payment.notifications || {}).merge( "#{notification_id}" => new_gateway_data)
        end

        def notification_id
          @notification_body[:id] || Time.current.to_s
        end

      end
    end
  end
end
