class VehiclesController < ApplicationController
  include ShipperLoader

  def index
    ensure_shipper; return if performed?

    vehicles = current_shipper.vehicles
    render json: vehicles, status: :ok # 200
  end

  def create
    ensure_shipper; return if performed?

    vehicle = current_shipper.vehicles.create(vehicles_params)
    # TODO: Create a service
    if vehicle.valid?
      render json: vehicle, status: :created # 201
    else
      render json: { error: vehicle.errors.full_messages }, status: :unprocessable_entity # 422
    end
  end

  def update
    ensure_shipper if params[:shipper_id]; return if performed?

    vehicle = current_shipper ? current_shipper.vehicles.find_by(id: params[:id]) : Vehicle.find_by(id: params[:id])

    if vehicle
      vehicle.update(vehicles_params)
      # TODO: Create a service
      if vehicle.valid?
        render json: vehicle, status: :ok # 200
      else
        render json: { error: vehicle.errors.full_messages }, status: :unprocessable_entity # 422
      end
    else
      render json: { error: I18n.t('not_found.vehicle', vehicle_id: params[:id]) }, status: :not_found # 404
    end
  end

  private

  def vehicles_params
    params.permit(
      :model,
      :brand,
      :year,
      :features
    )
  end
end


