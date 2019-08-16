module Gateway
  module Mercadopago
    class CancelRemotePayment

      def cancel_payment(payment)
        @account = PaymentGateway.account_for(payment.payable)
        @account.cancel_payment(payment.gateway_id)
      end
    end
  end
end