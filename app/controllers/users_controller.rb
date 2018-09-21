class UsersController < ApplicationController
  include CurrentAndEnsureDependencyLoader

  def index
    ensure_institution; return if performed?

    users = current_institution.users

    paginated_results = paginate(users)
    render json: paginated_results, status: :ok # 200
  end

  def create
    ensure_institution; return if performed?

    service = CreateUser.call(current_institution, user_params)

    if service.success?
      render json: service.result, status: :created # 201
    else
      render json: { errors: service.errors }, status: :unprocessable_entity # 422
    end
  end

  def update
    ensure_institution; return if performed?

    if user = current_institution.users.find_by(id: params[:id])
      service = UpdateUser.call(user, user_params)

      if service.success?
        render json: service.result, status: :ok # 200
      else
        render json: { errors: service.errors }, status: :unprocessable_entity # 422
      end
    else
      render json: { errors: I18n.t('errors.not_found.user', user_id: params[:id], institution_id: params[:institution_id]) }, status: :not_found # 404
    end
  end

  def destroy
    ensure_institution; return if performed?

    if user = current_institution.users.find_by(id: params[:id])
      if user.destroy
        render json: { user: user.id }, status: :ok # 200
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity # 422
      end
    else
      render json: { errors: I18n.t('errors.not_found.user', user_id: params[:id], institution_id: params[:institution_id]) }, status: :not_found # 404
    end
  end

  private

  def user_params
    params.permit(
      :username,
      :email,
      :password,
      :first_name,
      :last_name,
      :cellphone,
      :active
    )
  end

end
