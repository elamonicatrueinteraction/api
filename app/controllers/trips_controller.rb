class TripsController < ApplicationController

  def index
    trips = Trip.preload(:shipper, :orders, :deliveries, :packages).all
    render json: trips, status: :ok # 200
  end

  def create
    service = CreateTrip.call(create_trip_params)

    if service.success?
      Gateway::Shippify::DeliveryCreateWorker.perform_async(service.result.id)

      render json: service.result, status: :created # 201
    else
      render json: { errors: service.errors }, status: :unprocessable_entity # 422
    end
  end

  def show
    if trip = Trip.find_by(id: params[:id])
      render json: trip, status: :ok # 200
    else
      render json: { errors: I18n.t('errors.not_found.trip', id: params[:id]) }, status: :not_found # 404
    end
  end

  def update
    if trip = Trip.find_by(id: params[:id])
      service = UpdateTrip.call(trip, update_trip_params)

      if service.success?
        render json: service.result, status: :created # 201
      else
        render json: { errors: service.errors }, status: :unprocessable_entity # 422
      end
    else
      render json: { errors: I18n.t('errors.not_found.trip', id: params[:id]) }, status: :not_found # 404
    end
  end

  def destroy
    if trip = Trip.find_by(id: params[:id])

      service = DestroyTrip.call(trip)

      if service.success?
        render json: { trip: trip.id }, status: :ok # 200
      else
        render json: { errors: service.errors }, status: :unprocessable_entity # 422
      end
    else
      render json: { errors: I18n.t('errors.not_found.trip', id: params[:id]) }, status: :not_found # 404
    end
  end

  def broadcast
    if trip = Trip.find_by(id: params[:id])
      if trip.status.blank? || %w(draft scheduled processing).include?(trip.status)
        service = Gateway::Shippify::BroadcastRoute.call(trip)

        if service.success?
          render json: trip, status: :ok # 200
        else
          render json: { errors: service.errors }, status: :unprocessable_entity # 422
        end
      else
        render json: { errors: I18n.t('errors.trip.invalid_status', id: params[:id]) }, status: :unprocessable_entity # 422
      end
    else
      render json: { errors: I18n.t('errors.not_found.trip', id: params[:id]) }, status: :not_found # 404
    end
  end

  private

  def create_trip_params
    params.permit(
      :shipper_id,
      :comments,
      orders_ids: [],
      pickup_schedule: [:start, :end],
      dropoff_schedule: [:start, :end]
    )
  end

  def update_trip_params
    params.permit(
      :shipper_id,
      :status,
      :comments
    )
  end

end














