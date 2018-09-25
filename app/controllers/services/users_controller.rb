module Services
  class UsersController < BaseController

    def show
      if user = User.find_by(id: params[:id])
        render json: user, status: :ok # 200
      else
        render json: nil, status: :not_found # 404
      end
    end

    def index
      users = User.where(allowed_query_params)

      render json: users, each_serializer: choose_serializer, status: :ok # 200
    end

    def update
      if user = User.find_by(id: params[:id])
        user.update(allowed_update_params)

        render json: user, status: :ok # 200
      else
        render json: nil, status: :not_found # 404
      end
    end

    private

    def allowed_query_params
      params.permit(:email, :token_expire_at, :institution_id)
    end

    def allowed_update_params
      params.permit(:token_expire_at)
    end

    def choose_serializer
      params[:for_authenticate] ? Services::UserAuthenticationSerializer : Services::UserSerializer
    end

  end
end
