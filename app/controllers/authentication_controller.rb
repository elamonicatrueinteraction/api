class AuthenticationController < ApplicationController
  skip_before_action :authorize_request

  def authenticate
    service = AuthenticateUser.call(params[:email], params[:password], request.remote_ip)

    if service.success?
      render json: { auth_token: service.result }
    else
      render json: { errors: service.errors }, status: :unauthorized
    end
  end
end
