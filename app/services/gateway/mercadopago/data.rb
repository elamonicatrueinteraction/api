module Gateway
  module Mercadopago
    class Data

      def initialize(mercadopago_data)
        @mercadopago_data = mercadopago_data.with_indifferent_access
      end

      def status
        @mercadopago_data["response"]["status"].to_s
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
    end
  end
end
