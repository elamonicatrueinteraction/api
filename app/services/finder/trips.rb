module Finder
  class Trips
    prepend Service::Base

    def initialize(institution)
      @institution = institution
    end

    def call
      find_trips
    end

    private

    def find_trips
      @trips = Trip.preload(:shipper, :orders, :deliveries, :packages)
      @trips = @trips.where('id IN (?)', trips_ids) if @institution

      @trips
    end

    # TO-DO:  This is ugly as fuck!! :(, we should consider refactor the data model to improve
    # this and other aspects of the relationships between ORDER <-> TRIPS <-> DELIVERIES <-> INSTITUTIONS
    def trips_ids
      orders_ids = Finder::Orders.call(@institution).result.pluck(:id)

      Delivery.where('order_id IN (?)', orders_ids).pluck(:trip_id)
    end

  end
end
