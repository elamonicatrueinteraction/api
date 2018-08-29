module Services
  class UsersController < BaseController

    def show
      if user = User.find_by(id: params[:id])
        render json: user, status: :ok # 200
      else
        render json: nil, status: :not_found # 404
      end
    end

  end
end
