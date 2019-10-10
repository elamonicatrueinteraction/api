class FixMercadoPaymentStatus < ActiveRecord::Migration[5.1]
  def change
    Payment.unscoped.each do |payment|
      is_payed = payment.amount == payment.collected_amount
      payment.status = Payment::Types::APPROVED if is_payed
      payment.status = Payment::Types::PENDING if payment.status == "201" || payment.status == "400" || payment.status = "200"
      payment.save
    end
  end
end
