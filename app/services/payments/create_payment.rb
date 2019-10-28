module Payments
  class CreatePayment

    def initialize(donated_payment: DonatedPayment.new, gateway_router: Gateway::Router::GatewayRouter.new)
      @donated_payment = donated_payment
      @gateway_router = gateway_router
    end

    def create(payable: , payment_type:, amount: payable.amount, comment: '')
      payment = Payment.new({amount: amount, network_id: payable.network_id, comment: comment})
      payable.payments << payment
      payment.save!
      if amount == 0
        @donated_payment.create(payment)
      elsif payment_type == Payment::PaymentTypes::OTRO
        payment
      else
        gateway = @gateway_router.route_gateway(payment: payment, payment_type: payment_type,
                                                network_id: payable.network_id)
        gateway_call = gateway.create_payment(payment: payment, payment_type: payment_type)
        assigner = Gateway::GatewayDataAssigner.new
        assigner.assign(payment, gateway_call)
      end
    end
  end
end