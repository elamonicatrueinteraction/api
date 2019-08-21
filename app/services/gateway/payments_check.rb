module Gateway
  class PaymentsCheck

    def initialize(gateway_provider: PaymentGateway)
      @gateway_provider = gateway_provider
    end

    def check_payments
      pending_payments = PendingPayments.call.result
      pending_payments.each(&method(:gateway_check))
    end

    def gateway_check(payment)
      begin
        client = @gateway_provider.account_for(payment.payable)
        data = client.payment(payment.gateway_id)
        status = data.status
        update_payment(payment, data) if payment.status != status
      rescue StandardError

      end
    end

    def update_payment(payment, mercadopago_data)
      result = UpdatePayment.call(payment, mercadopago_data)
    end
  end
end
