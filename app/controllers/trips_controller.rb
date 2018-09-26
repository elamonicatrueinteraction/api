class TripsController < ApplicationController
  include CurrentAndEnsureDependencyLoader
  include Exporters::Streamable

  def index
    optional_institution; return if performed?

    finder = Finder::Trips.call(institution: current_institution, filter_params: filter_params)

    render json: list_results(finder.result), status: :ok # 200
  end

  def create
    service = CreateTrip.call(create_trip_params)

    if service.success?
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

  def pause
    if trip = Trip.find_by(id: params[:id])
      service = PauseTrip.call(trip)

      if service.success?
        render json: trip, status: :ok # 200
      else
        render json: { errors: service.errors }, status: :unprocessable_entity # 422
      end
    else
      render json: { errors: I18n.t('errors.not_found.trip', id: params[:id]) }, status: :not_found # 404
    end
  end

  def broadcast
    if trip = Trip.find_by(id: params[:id])
      service = BroadcastTrip.call(trip)

      if service.success?
        render json: trip, status: :ok # 200
      else
        render json: { errors: service.errors }, status: :unprocessable_entity # 422
      end
    else
      render json: { errors: I18n.t('errors.not_found.trip', id: params[:id]) }, status: :not_found # 404
    end
  end

  def export
    optional_institution; return if performed?

    finder = Finder::Trips.call(institution: current_institution, filter_params: filter_params)

    stream_xlsx Exporters::Trips, trips: finder.result
  end

  private

  def create_trip_params
    params.permit(
      :amount,
      :shipper_id,
      :comments,
      orders_ids: [],
      pickup_schedule: [:start, :end],
      dropoff_schedule: [:start, :end]
    )
  end

  def update_trip_params
    params.permit(
      :amount,
      :shipper_id,
      :comments,
      pickup_schedule: [:start, :end],
      dropoff_schedule: [:start, :end]
    )
  end

  def filter_params
    params.permit(
      :created_since,
      :created_until
    )
  end

end














