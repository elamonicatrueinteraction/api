module Gateway
  module Shippify
    class BroadcastRoute
      prepend Service::Base

      def initialize(trip)
        @trip = trip
      end

      def call
        broadcast_route
      end

      private

      def broadcast_route
        ::Shippify::Api::Route.broadcast( shippify_trip_id )

        response = ::Shippify::Dash.client.trip(id: shippify_trip_id)
        if shippify_trip_data = response['payload'].fetch('data', {})["route"]
          if shippify_trip_data["status"] == "broadcasting"
            @trip.update(status: shippify_trip_data["status"], gateway_data: shippify_trip_data)
            @trip.deliveries.each do |delivery|
              delivery.update(status: shippify_trip_data["status"])
            end
            return @trip
          end
        end

        errors.add(:error, I18n.t('services.gateway.shippify.broadcast_route.error', id: @trip.id )) && nil
      end

      def shippify_trip_id
         @trip.gateway_id
      end

    end
  end
end
