class CreatePayment
  prepend Service::Base

  def initialize(payable, amount, payment_type = nil, gateway_creator = Payments::CreateRemotePayment.new)
    @payable = payable
    @amount = amount.to_f
    @payment_type = if Payment.valid_payment_type?(payment_type)
                      payment_type
                    else
                      Payment.default_payment_type
                    end
    @exempt_payment = Payments::ExemptPayment.new
    @remote_payment_creator = gateway_creator
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
        params = payment_params(@payable)
        @payment = @payable.payments.create!(params)
        @payment = if @amount.zero?
                     @exempt_payment.create(@payment)
                   else
                     @remote_payment_creator.create(payment: @payment, payment_type: @payment_type)
                   end
        @payment.save!
      end
      UpdateTotalDebtWorker.perform_async(@payment.id) unless @payment.amount.zero?
    rescue StandardError => e
      Rails.logger.info "[CreatePayment] - Error: #{e.message}"
      errors.add(e.class.to_s, e.message)
      @within_transaction ? (raise Service::Error.new(self)) : (return nil)
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.info "[CreatePayment] - Error: #{e.message}"
      errors.add_multiple_errors(e.record.errors.messages)
      @within_transaction ? (raise Service::Error.new(self)) : (return nil)
    end
    @payment
  end

  def payment_params(payable)
    { amount: @amount, network_id: payable.network_id }
  end

end
