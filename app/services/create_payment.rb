class CreatePayment
  prepend Service::Base

  def initialize(payable, amount, payment_type = nil)
    @payable = payable
    @amount = amount.to_f
    @payment_type = Payment.valid_payment_type?(payment_type) ? payment_type_id : Payment.default_payment_type
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
        @payment = @payable.payments.create!( payment_params )

        gateway_call = Gateway::Mercadopago::CreatePayment.call(@payment, @payment_type, true)
        gateway_result = gateway_call.result

        gateway_id = gateway_result[:id]
        gateway_status = gateway_result[:status]

        @payment.update!(status: gateway_status, gateway: 'Mercadopago', gateway_id: gateway_id, gateway_data: gateway_result)
      end
    rescue Service::Error, ActiveRecord::RecordInvalid => e
      errors.add_multiple_errors( e.record.errors.messages )

      @within_transaction ? (raise Service::Error.new(self)) : (return nil)
    end

    @payment
  end

  def payment_params
    { amount: @amount }
  end

end