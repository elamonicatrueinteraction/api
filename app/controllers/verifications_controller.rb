class VerificationsController < ApplicationController
  include CurrentAndEnsureDependencyLoader

  def index
    ensure_vehicle; return if performed?

    verifications = current_vehicle.verifications

    paginated_results = paginate(verifications)
    render json: paginated_results, status: :ok # 200
  end

  def create
    ensure_vehicle; return if performed?

    service = CreateVerification.call(current_vehicle, verification_params, current_user)

    if service.success?
      render json: service.result, status: :created # 201
    else
      render json: { errors: service.errors }, status: :unprocessable_entity # 422
    end
  end

  def update
    ensure_vehicle; return if performed?

    if verification = current_vehicle.verifications.find_by(id: params[:id])

      service = UpdateVerification.call(verification, verification_params, current_user)

      if service.success?
        render json: service.result, status: :ok # 200
      else
        render json: { errors: service.errors }, status: :unprocessable_entity # 422
      end
    else
      render json: { errors: I18n.t('errors.not_found.verification', verification_id: params[:id], vehicle_id: params[:vehicle_id]) }, status: :not_found # 404
    end
  end

  def destroy
    ensure_vehicle; return if performed?

    if verification = current_vehicle.verifications.find_by(id: params[:id])

      if verification.destroy
        render json: { verification: verification.id }, status: :ok # 200
      else
        render json: { errors: verification.errors.full_messages }, status: :unprocessable_entity # 422
      end
    else
      render json: { errors: I18n.t('errors.not_found.verification', verification_id: params[:id], vehicle_id: params[:vehicle_id]) }, status: :not_found # 404
    end
  end

  private

  def verification_params
    params.permit(
      :type,
      :expire,
      :expire_at,
      :verified,
      information: {}
    )
  end
end
