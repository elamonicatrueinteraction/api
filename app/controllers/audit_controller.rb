class AuditController < ApplicationController

  skip_before_action :authorize_request
  skip_before_action :set_current_network

  def index
    render json: Audit.all, status: :ok
  end
end
