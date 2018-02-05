module Gateway
  module Shippify
    class AssignRoute
      prepend Service::Base

      def initialize(trip)
        @trip = trip
        @shipper = trip.shipper
      end

      def call
        assign_route
      end

      private

      def assign_route
        ::Shippify::Api::Route.assign( shippify_trip_id, shippify_shipper_id )

        response = ::Shippify::Dash.client.trip(id: shippify_trip_id)
        if shippify_trip_data = response['payload'].fetch('data', {})
          if shippify_trip_data["status"] == "broadcasting" && shippify_trip_data["courier"]["id"] == shippify_shipper_id.to_s
            @trip.update(status: shippify_trip_data["status"])shippify_shipper_id
            @trip.deliveries.each do |delivery|
              delivery.update(status: shippify_trip_data["status"])
            end
          end
        end

        errors.add(:error, I18n.t('services.gateway.shippify.assign_route.error', id: @trip.id )) && nil
      end

      def shippify_trip_id
         @shippify_trip_id ||= @trip.gateway_id
      end

      def shippify_shipper_id
        @shippify_shipper_id ||= @shipper.gateway_id
      end

    end
  end
end
