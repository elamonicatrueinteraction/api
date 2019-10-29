class PaymentsController < ApplicationController
  include CurrentAndEnsureDependencyLoader

  def index
    (optional_order || optional_delivery); return if performed?

    render json: list_results(current_payable.payments), status: :ok # 200
  end

  def create
    (optional_order || optional_delivery); return if performed?

    service = CreatePayment.call(payable: current_payable, amount: payment_amount,
                                 payment_type: payment_params[:payment_type_id])

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

  def obsolesce
    payment_id = params[:id]
    payment = Payment.includes(:payable).find(payment_id)
    if payment
      institution = payment.payable.receiver
      action = Payments::ObsolescePayment.new
      payment = action.obsolesce(payment: payment, institution: institution)
      render json: payment, serializer: V2::PaymentSerializer, status: :ok
    else
      render json: { error: "No se encontró el payment con id #{payment_id}" }, status: :not_found
    end
  end

  def payee
    router = Gateway::Router::GatewayRouter.new
    payable_type = payee_params[:payable_type]
    payment_type = payee_params[:payment_type]
    network_id = payee_params[:network_id]
    begin
      gateway = router.route_gateway_for(payable_type: payable_type, payment_type: payment_type, network_id: network_id)
      render json: gateway.payee
    rescue StandardError
      render json: {payee_name: 'Desconocido', email: 'Desconocido'}
    end
  end

  private

  def payee_params
    params.permit(
            :payable_type,
            :payment_type
    ).tap do |params|
      params[:network_id] = current_network
    end
  end

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
