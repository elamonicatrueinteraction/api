module V2
  class PaymentsController < ApplicationController
    def index
      render json: PaymentQuery.new(params).collection
    end

    # payment_date
    # comment
    # collected_amount
    # def update
  end
end
