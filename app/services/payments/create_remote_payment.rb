module Payments
  class CreateRemotePayment

    def initialize(gateway_router: Gateway::Router::GatewayRouter.new)
      @gateway_router = gateway_router
    end

    def create(payment:, payment_type:, network_id:)
      gateway = @gateway_router.route_gateway(payment: payment, payment_type: payment_type,
                                              network_id: network_id)
      gateway_call = gateway.create_payment(payment: payment, payment_type: payment_type)
      assigner = Gateway::GatewayDataAssigner.new
      assigner.assign(payment, gateway_call)
    end
  end
end