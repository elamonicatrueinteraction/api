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
        create_deliveries
      end

      private

      def create_deliveries
        shippify_deliveries = ::Shippify::Api.client.create_deliveries( deliveries_params )

        if shippify_deliveries

          # TO-DO: This service is doing to things and I don't thinks is a good idea
          # I rather change this but we need to have a better idea how to create routes in shippify.
          shippify_deliveries.each do |shippify_delivery_data|
            shippify_delivery = ::Shippify::Api.client.delivery( shippify_delivery_data["id"] )
            delivery = @deliveries.detect{|d| d.id.to_s == shippify_delivery.data["referenceId"] }
            delivery.update({
              gateway: 'Shippify',
              gateway_id: shippify_delivery.id,
              gateway_data: shippify_delivery.data
            })
          end

          # TO-DO: I hate this part, in general I don't like this approach, is soooo fragile! :(
          @trip.assign_attributes({ gateway: 'Shippify', gateway_id: shippify_deliveries.first["id"] })

          unless @trip.save
            errors.add_multiple_errors(@trip.errors.messages)
          end

          return @trip
        end

        errors.add(:error, I18n.t('services.gateway.shippify.create_delivery.error', id: @trip.id )) && nil
      end

      def deliveries_params
        {
          deliveries: @deliveries.map { |delivery| delivery_params(delivery) },
          groupId: @trip.id
        }
      end

      def delivery_params(delivery)
        {
          pickup: location_params(delivery.pickup).merge(pickup_date_params),
          dropoff: location_params(delivery.dropoff),
          packages: packages_params(delivery.packages),
          referenceId: delivery.id,
          cod: 0
        }
      end

      def location_params(location_data)
        contact = location_data[:contact]
        lat, lng = location_data[:latlng].split(',')

        {
          contact: {
            name: contact[:name],
            email: contact[:email],
            phonenumber: contact[:cellphone]
          },
          location: {
            address: lookup_address(location_data[:address]),
            instructions: location_data[:notes],
            lat: lat,
            lng: lng
          }
        }
      end

      def pickup_date_params
        return {} unless pickup_window = @trip.pickup_window

        pickup_datetime = pickup_window['start'].to_datetime

        # This is like this because Shippify needs it if they return an error:
        # "Pickup time invalid. Time should be at least 60 minutes later than current time"
        unix_timestamp = if pickup_datetime >= (Time.current + 61.minutes)
          pickup_datetime
        else
          (Time.current + 61.day)
        end.to_i

        { date: unix_timestamp * 1000 }
      end

      def lookup_address(address)
        [
          address[:street_1],
          [address[:zip_code], address[:city]].compact.join(' '),
          address[:state],
          address[:country]
        ].compact.join(', ')
      end

      def packages_params(packages)
        packages.map do |package|
          {
            id: package.id,
            name: package.description,
            size: package.size,
            qty: package.quantity
          }
        end
      end

    end
  end
end
