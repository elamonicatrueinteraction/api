module ShipperApi
  class TripsController < BaseController

    def index
      trips = current_shipper.trips.preload(:orders, :deliveries, :packages)
      render json: trips, status: :ok # 200
    end

    def show
      if trip = current_shipper.trips.find_by(id: params[:id])
        render json: trip, status: :ok # 200
      else
        render json: { errors: I18n.t('errors.not_found.trip', id: params[:id]) }, status: :not_found # 404
      end
    end

  end
end
