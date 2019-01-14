class PaymentsController < ApplicationController
  include CurrentAndEnsureDependencyLoader

  skip_before_action :authorize_request, only: [:show]
  before_action :authorize_user_without_roles, only: [:show]

  def index
    (optional_order || optional_delivery); return if performed?

    render json: list_results(current_payable.payments), status: :ok # 200
  end

  def create
    (optional_order || optional_delivery); return if performed?

    service = CreatePayment.call(current_payable, payment_amount, payment_params[:payment_type_id])

    if service.success?
      render json: service.result, status: :created # 201
    else
      render json: { errors: service.errors }, status: :unprocessable_entity # 422
    end
  end

  def show
    (optional_order || optional_delivery); return if performed?

    if payment = current_payable.payments.find_by(id: params[:id])
      render json: payment, status: :ok # 200
    else
      render json: { errors: I18n.t("errors.not_found.payment_on_payable.#{current_payable.class.name.downcase}", payment_id: params[:id], payable_id: current_payable.id) }, status: :not_found # 404
    end
  end

  private

  def payment_params
    params.permit(
      :amount,
      :payment_type_id
    )
  end

  def current_payable
    @current_payable ||= (current_order || current_delivery)
  end

  def payment_amount
    @payment_amount ||= if (amount_param = payment_params[:amount].to_f) > 0
      amount_param
    else
      current_payable.total_amount
    end
  end
end
