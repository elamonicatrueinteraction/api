module Payments
  class ObsolescePayment

    attr_reader :errors

    def initialize(debt_updater: TotalDebtUpdate.new, account_provider: Gateway::PaymentGateway)
      @debt_updater = debt_updater
      @account_provider = account_provider
      @errors = []
    end

    def obsolesce(payment:, institution:)
      gateway_client = @account_provider.account_for(payment.payable)
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


      # TODO: @author: Tom. Comentado por razones de seguridad
      # Lo comenté por temas de seguridad. Alguien podría cancelar el pago de una cuenta ajena sobre
      # la que no tiene derechos
      # Scheduler::Provider.logistic_scheduler.cancel_remote_payment_async(payment) if payment.has_remote?
    end
  end
end
