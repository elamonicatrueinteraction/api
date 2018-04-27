module ShipperApi
  class TripsController < BaseController
    def index
      trips = Trip.preload(:shipper, :orders, :deliveries, :packages).where(shipper: current_shipper)
      render json: trips, status: :ok # 200
    end
  end
end