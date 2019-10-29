class CreatePayment
  prepend Service::Base

  def initialize(payable:, amount:, payment_type: nil, payment_comment: "")
    @payable = payable
    @amount = amount.to_f
    @payment_type = if Payment.valid_payment_type?(payment_type)
                      payment_type
                    else
                      Payment.default_payment_type
                    end
    @payment_comment = payment_comment
    @create_payment = Payments::CreatePayment.new
  end

  def call
    if @payable.has_active_payments?
      return errors.add(:type, I18n.t("services.create_payment.#{@payable.class.name.downcase}.has_active_payments", id: @payable.id)) && nil
    end

    create_payment
  end

  def create_payment
    begin
      Payment.transaction do
        payment = @create_payment.create(payable: @payable, payment_type: @payment_type, amount: @amount)
        payment.save!
        return payment
      end
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
end
