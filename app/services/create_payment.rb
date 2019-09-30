class CreatePayment
  prepend Service::Base

  def initialize(payable:, amount:, payment_type: nil, payment_comment: "",
                 gateway_creator: Payments::CreateRemotePayment.new)
    @payable = payable
    @amount = amount.to_f
    @payment_type = if Payment.valid_payment_type?(payment_type)
                      payment_type
                    else
                      Payment.default_payment_type
                    end
    @donated_payment = Payments::DonatedPayment.new

    @remote_payment_creator = gateway_creator
    @payment_comment = payment_comment
  end

  def call
    if @payable.has_active_payments?
      return errors.add(:type, I18n.t("services.create_payment.#{@payable.class.name.downcase}.has_active_payments", id: @payable.id)) && nil
    end

    create_payment
  end

  private

  def use_mercadopago(payment_type:)
    payment_type == Payment::PaymentTypes::PAGOFACIL || payment_type == Payment::PaymentTypes::RAPIPAGO
  end

  def create_payment
    begin
      Payment.transaction do
        params = payment_params(payable: @payable, comment: @payment_comment)
        @payment = @payable.payments.create!(params)
        @payment = if @amount.zero?
                     @donated_payment.create(@payment)
                   elsif use_mercadopago(payment_type: @payment_type)
                     @remote_payment_creator.create(payment: @payment, payment_type: @payment_type)
                   else
                     @payment.status = Payment::Types::PENDING
                     @payment
                   end
        @payment.save!
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

  def payment_params(payable:, comment:)
    { amount: @amount, network_id: payable.network_id, comment: comment }
  end

end
