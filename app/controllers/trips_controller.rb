class TripsController < ApplicationController

  def index
    trips = Trip.preload(:deliveries, :shippers, :packages).all
    render json: trips, status: :ok # 200
  end

  def create
    service = CreateTrip.call(create_trip_params)

    if service.success?
      render json: service.result, status: :created # 201
    else
      render json: { error: service.errors }, status: :unprocessable_entity # 422
    end
  end

  def show
    if trip = Trip.find_by(id: params[:id])
      render json: trip, status: :ok # 200
    else
      render json: { error: I18n.t('errors.not_found.trip', id: params[:id]) }, status: :not_found # 404
    end
  end

  def update
    if trip = Trip.find_by(id: params[:id])
      service = UpdateTrip.call(trip, update_trip_params)

      if service.success?
        render json: service.result, status: :created # 201
      else
        render json: { error: service.errors }, status: :unprocessable_entity # 422
      end
    else
      render json: { error: I18n.t('errors.not_found.trip', id: params[:id]) }, status: :not_found # 404
    end
  end

  def destroy
    if trip = Trip.find_by(id: params[:id])
      service = DestroyTrip.call(trip)

      if service.success?
        render json: { trip: trip.id }, status: :ok # 200
      else
        render json: { error: service.errors }, status: :unprocessable_entity # 422
      end
    else
      render json: { error: I18n.t('errors.not_found.trip', id: params[:id]) }, status: :not_found # 404
    end
  end

  private

  def create_trip_params
    params.permit(
      :shipper_id,
      :order_id,
      :schedule_at,
      :comments
    )
  end

  def update_trip_params
    params.permit(
      :shipper_id,
      :schedule_at,
      :comments
    )
  end

end














