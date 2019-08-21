module Gateway
  class UpdatePayment
    prepend Service::Base

    def initialize(payment, gateway_data)
      @payment = payment
      @gateway_data = gateway_data
    end

    def call
      update
    end

    private

    def update
      state = @gateway_data.status
      if state == Payment::Types::APPROVED
        approved
      elsif state != Payment::Types::PENDING
        update_status(state)
      else
        @payment
      end
    end

    def approved
      @payment.collected_amount = @gateway_data.total_paid_amount
      @payment.paid_at = @gateway_data.paid_at
      @payment.gateway_data = @gateway_data.raw_data
      @payment.status = Payment::Types::APPROVED
      @payment
    end

    def update_status(status)
      @payment.status = status
      @payment
    end
  end
end