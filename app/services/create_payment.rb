class CreatePayment
  prepend Service::Base

  def initialize(payable, amount, payment_type = nil)
    @payable = payable
    @amount = amount.to_f
    @payment_type = if Payment.valid_payment_type?(payment_type)
      payment_type
    else
      Payment.default_payment_type
    end
  end

  def call
    if @payable.has_active_payments?
      return errors.add(:type, I18n.t("services.create_payment.#{@payable.class.name.downcase}.has_active_payments", id: @payable.id)) && nil
    end

    create_payment
  end

  private

  def create_payment
    begin
      Payment.transaction do
        @payment = @payable.payments.create!(payment_params(@payable))
        gateway_call = Gateway::Mercadopago::CreatePayment.call(@payment, @payment_type, true)
        gateway_result = gateway_call.result
        assigner = Gateway::GatewayDataAssigner.new
        @payment = assigner.assign(@payment, gateway_result)
        @payment.save!
      end
      UpdateTotalDebtWorker.perform_async(@payment.id)
    rescue StandardError, ActiveRecord::RecordInvalid => e
      Rails.logger.info "[CreatePayment] - Error: #{e.message}"
      errors.add_multiple_errors( e.record.errors.messages )

      @within_transaction ? (raise Service::Error.new(self)) : (return nil)
    end

    @payment
  end

  def payment_params(payable)
    { amount: @amount, network_id: payable.network_id }
  end

end
