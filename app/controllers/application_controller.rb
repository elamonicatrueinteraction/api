class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionController::MimeResponds
  include PagingStuff

  before_action :authorize_request
  before_action :set_current_network, if: :current_user

  attr_reader :current_user

  private

  def set_current_network
    Rails.logger.info "Network: #{current_network}"
    ApplicationRecord.current_network = current_network
    UserApiResource.default_scope_by_network(current_network)
    UserApiResource.current_network = current_network
  end

  def current_network
    @current_network ||= request.headers.fetch('X-Network-Id', current_user.networks.first)
  end

  def authorize_request
    authorize_user || render_unauthorized('Nilus - Logistics API')
  end

  def authorize_user_without_roles
    authenticate_with_http_token do |token, _options|
      @current_user ||= AuthorizeUser.call(token, request, false).result
    end
  end

  def authorize_user
    authenticate_with_http_token do |token, _options|
      @current_user ||= AuthorizeUser.call(token, request).result
    end
  end

  def render_unauthorized(realm = "Application")
    self.headers['WWW-Authenticate'] = %(Token realm="#{realm.gsub(/"/, "")}")
    render json: { message: 'Not Authorized' }, status: :unauthorized
  end
end
