class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  before_action :authorize_request

  attr_reader :current_user

  private

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
