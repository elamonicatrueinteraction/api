module Gateway
  module Shippify
    class CreateDelivery
      prepend Service::Base
      include Support::Place

      def initialize(trip)
        @trip = trip
        @deliveries = trip.deliveries
      end

      def call
        create_delivery
      end

      private

      def create_delivery
        shippify_delivery = ::Shippify::Api::Delivery.create( deliveries_params )

        if shippify_delivery
          @trip.assign_attributes({ gateway: 'Shippify', gateway_id: shippify_delivery.id })

          unless @trip.save
            errors.add_multiple_errors(@trip.errors.messages)
          end

          return @trip
        end

        errors.add(:error, I18n.t('services.gateway.shippify.create_delivery.error', id: @trip.id )) && nil
      end

      def deliveries_params
        {
          deliveries: @deliveries.map { |delivery| delivery_params(delivery) }
        }
      end

      # def delivery_params(delivery)
      #   pickup = @trip.
      # end

    end
  end
end
