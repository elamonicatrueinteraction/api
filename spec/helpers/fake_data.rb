class FakeData

  attr_reader :status, :paid_at, :total_fees, :raw_data

  def initialize(payment:, status:, paid_at:, total_fees:, raw_data: )
    @payment = payment
    @raw_data = raw_data
    @status = status
    @paid_at = paid_at
    @total_fees = total_fees
    @raw_data = raw_data
  end

  def payment_id
    @payment.gateway_id
  end

  def gateway
    'Mercadopago'
  end

  def total_paid_amount
    @payment.amount
  end
end
