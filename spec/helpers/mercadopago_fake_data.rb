class MercadopagoFakeData

  def initialize(payment: , status: , paid_at: , total_fees: , raw_data: )
    @payment = payment
    @raw_data = raw_data
    @status = status
    @paid_at = paid_at
    @total_fees = total_fees
    @raw_data = raw_datasub
  end

  def status
    @status
  end

  def payment_id
    @payment.gateway_id
  end

  def paid_at
    @paid_at
  end

  def gateway
    'Mercadopago'
  end

  def total_paid_amount
    @payment.amount
  end

  def total_fees
    @total_fees
  end

  def raw_data
    @raw_data
  end
end