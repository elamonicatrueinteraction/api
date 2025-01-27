module V2
  class PaymentsController < ApplicationController
    skip_before_action :authorize_request, only: [:index]
    before_action :authorize_user_without_roles, only: [:index]

    def index
      payments = PaymentQuery.new(params).collection
      render json: payments
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
