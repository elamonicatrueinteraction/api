module ShipperApi
  class AuthenticationController < BaseController
    skip_before_action :authorize_request

    def authenticate
      service = ShipperApi::AuthenticateShipper.call(params[:email], params[:password], request.remote_ip)

      if service.success?
        render json: { auth_token: service.result }
      else
        render json: { errors: service.errors }, status: :unprocessable_entity
      end
    end
  end
end