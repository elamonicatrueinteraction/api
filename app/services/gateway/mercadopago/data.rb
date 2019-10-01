module Gateway
  module Mercadopago
    class Data

      def initialize(mercadopago_data)
        @mercadopago_data = mercadopago_data.with_indifferent_access
      end

      def status
        expired? ? "expired" : @mercadopago_data["response"]["status"].to_s
      end

      def payment_id
        @mercadopago_data["response"]["id"]
      end

      def paid_at
        @mercadopago_data["response"]["date_approved"]
      end

      def gateway
        'Mercadopago'
      end

      def total_paid_amount
        transaction_details = @mercadopago_data["response"]["transaction_details"]
        return nil if transaction_details.nil?

        transaction_details["total_paid_amount"]
      end

      def total_fees
        @mercadopago_data["response"]["fee_details"]&.sum{ |k| k["amount"]}
      end

      def raw_data
        @mercadopago_data
      end

      def expired?
        expiration_date = expiration_date_utc
        return false if expiration_date.nil?

        @mercadopago_data["response"]["status"].to_s == "pending" && expiration_date <= Time.now.utc
      end

      def expiration_date_utc
        expiration_date = @mercadopago_data["response"]["date_of_expiration"]
        return nil if expiration_date.nil?

        Time.parse(@mercadopago_data["response"]["date_of_expiration"]).utc
      end
    end
  end
end
