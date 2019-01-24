module Services
  class BaseController < ActionController::API
    include ActionController::HttpAuthentication::Token::ControllerMethods
    NILUS_SERVICES_TOKENS = {
      user: Rails.application.secrets.user_token,
      marketplace: Rails.application.secrets.marketplace_token
    }.freeze

    before_action :authorize_request

    private

    def authorize_request
      authorize_service || render_unauthorized('Nilus Logistics-API - Resources')
    end

    def authorize_service
      authenticate_with_http_token do |token, options|
        NILUS_SERVICES_TOKENS.values.include?(token)
      end
    end

    def render_unauthorized(realm = "Application")
      self.headers['WWW-Authenticate'] = %(Token realm="#{realm.gsub(/"/, "")}")
      render json: { message: 'Not Authorized' }, status: :unauthorized
    end

  end
end
