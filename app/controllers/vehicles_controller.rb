class VehiclesController < ApplicationController
  include CurrentAndEnsureDependencyLoader

  def index
    ensure_shipper; return if performed?

    vehicles = current_shipper.vehicles
    render json: vehicles, status: :ok # 200
  end

  def create
    ensure_shipper; return if performed?

    vehicle = current_shipper.vehicles.create(vehicle_params)
    # TODO: Create a service
    if vehicle.valid?
      Gateway::Shippify::VehicleWorker.perform_async(vehicle.id, 'create')

      render json: vehicle, status: :created # 201
    else
      render json: { errors: vehicle.errors.full_messages }, status: :unprocessable_entity # 422
    end
  end

  def update
    ensure_shipper if params[:shipper_id]; return if performed?

    vehicle = current_shipper ? current_shipper.vehicles.find_by(id: params[:id]) : Vehicle.find_by(id: params[:id])

    if vehicle
      vehicle.update(vehicle_params)
      # TODO: Create a service
      if vehicle.valid?
        Gateway::Shippify::VehicleWorker.perform_async(vehicle.id, 'update')

        render json: vehicle, status: :ok # 200
      else
        render json: { errors: vehicle.errors.full_messages }, status: :unprocessable_entity # 422
      end
    else
      render json: { errors: [ I18n.t('errors.not_found.vehicle', id: params[:id]) ] }, status: :not_found # 404
    end
  end

  private

  def vehicle_params
    params.permit(
      :model,
      :brand,
      :year,
      :features
    )
  end
end




