module Payments
  class PendingPayments
    prepend Service::Base

    def call
      pending_payments
    end

    private

    def pending_payments
      Payment.includes(:payable).where(status: Payment::Types::PENDING)
    end
  end
end