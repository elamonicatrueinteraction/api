class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionController::MimeResponds
  include PagingStuff

  before_action :authorize_request

  attr_reader :current_user

  private

  def authorize_request
    authorize_user || render_unauthorized('Nilus - Logistics API')
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
