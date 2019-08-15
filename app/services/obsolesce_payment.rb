class ObsolescePayment

  attr_reader :errors

  def initialize(debt_updater:, gateway_client:, update_payment:, cancel_payment:)
    @debt_updater = debt_updater
    @gateway_client = gateway_client
    @cancel_payment = cancel_payment
    @update_payment = update_payment
    @errors = []
  end

  def obsolesce(payment)
    payment_is_paid = payment.approved?
    if payment_is_paid
      errors << "El pago ya ha sido efectuado"
      return
    end
    remote_payment_is_paid = @gateway_client.paid?(payment.gateway_id)
    if remote_payment_is_paid
      errors << "El correspondiente externo del pago ya ha sido pagado"
      @update_payment.update_async(payment)
      return
    end
    payment.status = "obsolete"
    payment.save!
    @cancel_payment.update_async(payment)
    @debt_updater.update
  end
end
