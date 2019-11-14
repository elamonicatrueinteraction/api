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
        email = allowed_params[:email]
        has_accepted_tdu = Shipper.find_by(email: email).has_accepted_tdu
        render json: { auth_token: service.result, has_accepted_tdu: has_accepted_tdu }
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
