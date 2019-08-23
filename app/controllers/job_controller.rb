class JobController < ApplicationController

  before_action :authorize
  skip_before_action :authorize_request
  skip_before_action :set_current_network

  def sync_coupons
    Rails.logger.info '[PaymentSync] - Starting Sync'
    begin
      payment_sync = Gateway::PaymentSync.new
      debt_update = Payments::UpdateInstitutionDebt.new
      payment_sync.sync_payments
      Rails.logger.info '[PaymentSync] - Sync ended succesfully!'
      Rails.logger.info '[PaymentSync] - Updating institution debt...'
      debt_update.update_all
      Rails.logger.info '[PaymentSync] - Finished updating institution debt...'
      return render plain: "OK", status: :ok
    rescue StandardError => e
      Rails.logger.info "[PaymentSync] - ERROR in payment sync. Message: #{e}"
      return render plain: "ERROR #{e.message}", status: :internal_server_error
    end
  end

  def sync_missing_coupons
    Rails.logger.info '[MissingPaymentSync] - Starting Sync'
    begin
      payment_sync = Gateway::RemoteNotFoundPaymentSync.new
      debt_update = Payments::UpdateInstitutionDebt.new
      payment_sync.sync_payments
      Rails.logger.info '[MissingPaymentSync] - Sync ended succesfully!'
      Rails.logger.info '[MissingPaymentSync] - Updating institution debt...'
      debt_update.update_all
      Rails.logger.info '[MissingPaymentSync] - Finished updating institution debt...'
      return render plain: "OK", status: :ok
    rescue StandardError => e
      Rails.logger.info "[MissingPaymentSync] - ERROR in payment sync. Message: #{e}"
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
    data = payment_canceler.cancel_payment(payment)
    if data.raw_data['status'].to_i == 200
      render plain: "OK", status: :ok
    else
      render plain: "Cancellation was unsuccesfull", status: :bad_request
    end
  end

  private

  def authorize
    token_matches = Rails.application.secrets.job_token == permitted_params[:token]
    render json: { message: 'Unauthorized' }, status: :unauthorized unless token_matches
  end

  def cancel_payment_params
    params.permit(:payment_id)
  end

  def permitted_params
    params.permit(:token)
  end
end
