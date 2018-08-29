module Services
  class BaseController < ActionController::API
    include ActionController::HttpAuthentication::Token::ControllerMethods

    before_action :authorize_request

    def hello
      render json: { data: "Hi! ready when you are" }, status: :ok
    end

    def authorize_user
      service = AuthorizeUser.call(params[:http_auth_header])

      if service.success? && (user = service.result)
        render json: { user_id: user.id }, status: :ok
      else
        render json: { user_id: nil }, status: :unprocessable_entity
      end
    end

    private

    def authorize_request
      authenticate_service || render_unauthorized('Nilus API - Services')
    end

    def authenticate_service
      authenticate_with_http_token do |token, options|
        SERVICES_TOKENS.values.include?(token)
      end
    end

    def render_unauthorized(realm = "Application")
      self.headers['WWW-Authenticate'] = %(Token realm="#{realm.gsub(/"/, "")}")
      render json: { message: 'Not Authorized' }, status: :unauthorized
    end

  end
end
