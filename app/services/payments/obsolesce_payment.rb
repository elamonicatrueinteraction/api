module Payments
  class ObsolescePayment

    attr_reader :errors

    def initialize(debt_updater: TotalDebtUpdate.new, gateway_router: Gateway::Router::GatewayRouter.new)
      @debt_updater = debt_updater
      @gateway_router = gateway_router
      @errors = []
    end

    def obsolesce(payment:, institution:)
      gateway_client = @gateway_router.route_gateway_for
      payment_is_paid = payment.approved?
      if payment_is_paid
        errors << "El pago ya ha sido efectuado"
        return
      end
      if payment.has_remote?
        remote_payment_is_paid = gateway_client.paid?(payment.gateway_id)
        if remote_payment_is_paid
          errors << "El correspondiente externo del pago ya ha sido pagado"
          return
        end
      end
      payment.obsolesce
      payment.save!

      @debt_updater.update_debt_for(institution: institution)
      Scheduler::Provider.logistic_scheduler.cancel_remote_payment_async(payment) if payment.has_remote?

      payment
    end
  end
end
