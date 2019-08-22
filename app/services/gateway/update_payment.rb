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
      status = @gateway_data.status
      if status == Payment::Types::APPROVED
        approved
      elsif status == "404"
        update_not_found
      elsif status != Payment::Types::PENDING
        update_status(status)
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
      @payment.gateway_data = @gateway_data.raw_data
      @payment
    end

    def update_not_found
      @payment.gateway_data = @payment.gateway_data.merge!({ when_searched_with_all_tokens_got: "404" })
      @payment
    end
  end
end
