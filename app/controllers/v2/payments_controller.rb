module V2
  class PaymentsController < ApplicationController
    def index
      render json: PaymentQuery.new(params).collection
    end

    def update
      payment = Payment.find(params.require(:id))

      if payment.update(permitted_params)
        UpdateTotalDebtWorker.perform_async(payment.id)
        render json: payment
      else
        render json: payment.errors, status: :unprocessable_entity
      end
    end

    private

    def permitted_params
      params.require(:payment).permit(:paid_at, :comment, :collected_amount)
    end
  end
end
