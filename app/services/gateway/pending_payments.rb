module Gateway
  class PendingPayments
    prepend Service::Base

    def call
      get_pending_payments
    end

    private

    def get_pending_payments
      Payment.where(status: Payment::Types::PENDING)
    end
  end
end