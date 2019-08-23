class FixMercadoPagoPaymentStatus < ActiveRecord::Migration[5.1]
  def change
    Payment.unscoped.each do |payment|
      is_payed = payment.amount == payment.collected_amount
      payment.status = "accepted" if is_payed
      payment.status = "pending" if payment.status == "201" || payment.status == "400"
      payment.save
    end
  end
end
