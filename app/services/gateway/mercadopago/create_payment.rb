module Gateway
  module Mercadopago
    class CreatePayment

      def initialize(credentials:)
        @credentials = credentials
        @client = Gateway::Mercadopago::MercadopagoClient.new(credentials[:access_token])
      end

      def create(payment: , payment_type:, description: )
        email = @credentials[:email]
        payload = make_payload(payment: payment, payment_type: payment_type, email: email, description: description)
        @client.create_payment(payload)
      end

      private

      def make_payload(payment: , payment_type: , email:, description: )
        {
          transaction_amount: payment.amount.to_f,
          description: description,
          payment_method_id: payment_type,
          statement_descriptor: "NILUS",
          payer: {
            email: email
          },
          external_reference: payment.id
        }.tap do |_hash|
          if Rails.application.secrets.mercadopago_notification_host.present?
            # We user the URL helper like this because they are not available in the services nor the models
            _hash[:notification_url] = Rails.application.routes.url_helpers.webhooks_mercadopago_payment_url(
              protocol: 'https',
              host: Rails.application.secrets.mercadopago_notification_host,
              uuid: payment.id
            )
          end
        end
      end
    end
  end
end
