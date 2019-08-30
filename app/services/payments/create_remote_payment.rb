module Payments
  class CreateRemotePayment

    def create(payment:, payment_type:)
      gateway_call = Gateway::Mercadopago::CreatePayment.call(payment, payment_type, true)
      gateway_result = gateway_call.result
      assigner = Gateway::GatewayDataAssigner.new
      assigner.assign(payment, gateway_result)
    end
  end
end