class JobController < ApplicationController

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

  private

  def authorize
    token_matches = ENV['TESTING_TOKEN'] == permitted_params[:token]
    render json: { message: 'Unauthorized' }, status: :unauthorized unless token_matches
  end

  def permitted_params
    params.permit(:token)
  end
end