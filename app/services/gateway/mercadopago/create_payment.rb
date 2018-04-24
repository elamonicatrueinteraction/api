module Gateway
  module Mercadopago
    class CreatePayment
      prepend Service::Base

      def initialize(payment, payment_type, within_transaction = false)
        @payment = payment
        @payment_type = payment_type
        @within_transaction = within_transaction
        @account = PaymentGateway.account_for(@payment.payable)
      end

      def call
        create_payment
      end

      private

      def create_payment
        begin
          @account.create_payment( coupon_payment_payload )
        rescue StandardError => e
          errors.add_multiple_errors( e.errors.messages )

          @within_transaction ? (raise Service::Error.new(self)) : (return nil)
        end
      end

      def coupon_payment_payload
        {
          transaction_amount: @payment.amount.to_f,
          description: payment_description,
          payment_method_id: @payment_type,
          statement_descriptor: "NILUS",
          payer: {
            email: payer_email
          },
          external_reference: @payment.id,
          idempotency_key: @payment.id
        }.tap do |_hash|
          if MERCADOPAGO_CONFIG['notification_host'].present?
            # We user the URL helper like this because they are not available in the services nor the models
            _hash[:notification_url] = Rails.application.routes.url_helpers.webhooks_mercadopago_payment_url(
              protocol: SECURE_PROTOCOL,
              host: MERCADOPAGO_CONFIG['notification_host'],
              uuid: @payment.id
            )
          end
        end
      end

      def payment_description
        if @payment.payable.is_a?(Order)
          "NILUS/BAR - Pago por la orden ##{@payment.payable_id}"
        else
          "NILUS - Pago por la entrega ##{@payment.payable_id}"
        end
      end

      def payer_email
        MERCADOPAGO_CONFIG['payer_email']
      end

    end
  end
end
