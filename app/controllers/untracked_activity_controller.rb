class UntrackedActivityController < ApplicationController

  def create
    operation = UntrackedActivities::CreateUntrackedActivity.call(params: create_params)
    if operation.success?
      render json: operation.result.payments.first, serializer: PaymentSerializer, status: :created
    else
      render json: { errors: operation.errors }, status: :unprocessable_entity
    end
  end

  private

  def create_params
    params.require(:activity).permit(
      :reason,
      :institution_id,
      :amount,
      :payment_method,
      :activity
    ).tap do |params|
      params[:network_id] = current_network
      params[:author_id] = current_user.id
    end
  end
end
