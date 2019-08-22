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

  private

  def authorize
    token_matches = ENV['JOB_TOKEN'] == permitted_params[:token]
    render json: { message: 'Unauthorized' }, status: :unauthorized unless token_matches
  end

  def permitted_params
    params.permit(:token)
  end
end
