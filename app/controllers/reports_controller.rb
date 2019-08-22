class ReportsController < ApplicationController

  before_action :authorize
  skip_before_action :authorize_request
  skip_before_action :set_current_network

  def remote_payment_report
    payments = Payment.all.includes(:payable)
    csv = Reports::RemotePaymentReport.new.make_csv(payments)
    respond_to do |format|
      format.html
      format.csv { send_data csv, filename: "mercadopago.csv" }
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