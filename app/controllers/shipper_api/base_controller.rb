module ShipperApi
  class BaseController < ActionController::API
    before_action :authorize_request

    attr_reader :current_shipper

    def hello
      render json: { data: "Hi #{current_shipper.first_name}! ready when you are" }, status: :ok
    end

    private

    def authorize_request
      authenticate_shipper || render_unauthorized('Nilus Shipper API')
    end

    def authenticate_shipper
      @current_shipper ||= ShipperApi::AuthorizeRequest.call(request.headers).result
    end

    def render_unauthorized(realm = "Application")
      self.headers['WWW-Authenticate'] = %(Token realm="#{realm.gsub(/"/, "")}")
      render json: { message: 'Not Authorized' }, status: :unauthorized
    end

  end
end
