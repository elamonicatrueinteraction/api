module Finder
  class Trips
    prepend Service::Base
    include Service::Support::Finders

    def initialize(institution: nil, filter_params: {})
      @institution = institution
      @filter_params = filter_params
    end

    def call
      find_trips
    end

    private

    def find_trips
      @trips = Trip.includes(:audits, :shipper, :trip_assignments, :milestones, deliveries: [:order, :packages, :payments], orders: [:payments, { deliveries: [:packages, :payments] }])
      @trips = @trips.where('id IN (?)', trips_ids) if @institution
      @trips = @trips.where('DATE(created_at) >= ?', created_since) if created_since
      @trips = @trips.where('DATE(created_at) <= ?', created_until) if created_until
      @trips = @trips.delivery_at(delivery_at) if delivery_at

      @trips.order(created_at: :desc)
    end

    def delivery_at
      @filter_params[:delivery_at]
    end

    # TO-DO:  This is ugly as fuck!! :(, we should consider refactor the data model to improve
    # this and other aspects of the relationships between ORDER <-> TRIPS <-> DELIVERIES <-> INSTITUTIONS
    def trips_ids
      orders_ids = Finder::Orders.call(institution_id: @institution&.id).result.pluck(:id)

      Delivery.where('order_id IN (?)', orders_ids).pluck(:trip_id)
    end

  end
end
