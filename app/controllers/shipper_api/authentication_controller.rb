module ShipperApi
  class AuthenticationController < BaseController
    skip_before_action :authorize_request

    def authenticate
      service = ShipperApi::AuthenticateShipper.call(
        allowed_params[:email],
        allowed_params[:password],
        allowed_params[:device],
        request.remote_ip
      )

      if service.success?
        render json: { auth_token: service.result }
      else
        render json: { errors: service.errors }, status: :unprocessable_entity
      end
    end

    private

    def allowed_params
      params.permit(
        :email,
        :password,
        device: {}
      )
    end

  end
end
