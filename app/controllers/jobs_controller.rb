class JobsController < ApplicationController

  before_action :authorize
  skip_before_action :authorize_request
  skip_before_action :set_current_network

  def sync_coupons
    Rails.logger.info '[PaymentMercadopagoSync] - Starting Sync'
    begin
      Gateway::Mercadopago::PaymentMercadopagoSync::PaymentsCheck.call
      Rails.logger.info '[PaymentMercadopagoSync] - Sync ended succesfully!'
      return render plain: "OK", status: :ok
    rescue StandardError => e
      Rails.logger.info "[PaymentMercadopagoSync] - ERROR in payment sync. Message: #{e}"
      return render plain: "ERROR #{e.message}", status: :internal_server_error
    end
  end

  def cancel_remote_payment
    payment_id = cancel_payment_params[:payment_id]
    payment = Payment.find_by(id: payment_id)
    return render plain: "El pago con id #{payment_id} no fue encontrado", status: :not_found if payment.nil?
    unless payment.has_remote?
      return render plain: "El pago con id #{payment_id} no tiene remote asociado", status: :unprocessable_entity
    end
    payment_canceler = Gateway::Mercadopago::CancelRemotePayment.new
    response = payment_canceler.cancel_payment(payment)
    if response["status"].to_i == 200
      render plain: "OK", status: :ok
    else
      render plain: "Cancellation was unsuccesfull", status: :bad_request
    end
  end

  private

  def authorize
    token_matches = Rails.application.secrets.job_token == auth_params[:token]
    render json: { message: 'Unauthorized' }, status: :unauthorized unless token_matches
  end

  def cancel_payment_params
    params.permit(:payment_id)
  end

  def auth_params
    params.permit(:token)
  end
end
