class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include PagingStuff

  before_action :authorize_request
  before_action :set_current_network, if: :current_user

  attr_reader :current_user

  private

  def set_current_network
    Rails.logger.info "Network: #{current_network}"
    ApplicationRecord.current_network = current_network
  end

  def current_network
    @current_network ||= request.headers.fetch('X-Network-Id', current_user.networks.first)
  end

  def authorize_request
    authenticate_user || render_unauthorized('Nilus API')
  end

  def authenticate_user
    @current_user ||= AuthorizeRequest.call(request.headers).result
  end

  def render_unauthorized(realm = "Application")
    self.headers['WWW-Authenticate'] = %(Token realm="#{realm.gsub(/"/, "")}")
    render json: { message: 'Not Authorized' }, status: :unauthorized
  end
end
