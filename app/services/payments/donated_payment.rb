module Payments
  class DonatedPayment

    def create(payment)
      payment.status = Payment::Types::APPROVED
      payment.collected_amount = 0
      payment.save!
      payment
    end
  end
end