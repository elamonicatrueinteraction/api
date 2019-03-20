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
          email = payer_email
          payload = coupon_payment_payload(email)
          @account.create_payment(payload)
        rescue StandardError => e
          errors.add_multiple_errors( e.errors.messages )

          @within_transaction ? (raise Service::Error.new(self)) : (return nil)
        end
      end

      def coupon_payment_payload(email)
        {
          transaction_amount: @payment.amount.to_f,
          description: payment_description,
          payment_method_id: @payment_type,
          statement_descriptor: "NILUS",
          payer: {
            email: email
          },
          external_reference: @payment.id,
          idempotency_key: @payment.id
        }.tap do |_hash|
          if Rails.application.secrets.mercadopago_notification_host.present?
            # We user the URL helper like this because they are not available in the services nor the models
            _hash[:notification_url] = Rails.application.routes.url_helpers.webhooks_mercadopago_payment_url(
              protocol: 'https',
              host: Rails.application.secrets.mercadopago_notification_host,
              uuid: @payment.id
            )
          end
        end
      end

      def payment_description
        if @payment.payable.is_a?(Order)
          "Pedido Nilus de '#{@payment.payable&.receiver&.name}' por la orden ##{@payment.payable_id}"
        else
          "NILUS - Pago por la entrega ##{@payment.payable_id}"
        end
      end

      def payment_institution
        @payment.payable.network_id == 'MDQ' ? 'MDQ' : 'BAR'
      end

      def payer_email
        emails = {
          nilus: Rails.application.secrets.mercadopago_payer_email_nilus,
          bar: Rails.application.secrets.mercadopago_payer_email_bar,
          mdq: Rails.application.secrets.mercadopago_payer_email_mdq
        }
        if @payment.payable.is_a?(Order)
          @payment.payable.network_id == 'ROS' ? emails[:bar] : emails[:mdq]
        else
          emails[:nilus]
        end
      end
    end
  end
end
