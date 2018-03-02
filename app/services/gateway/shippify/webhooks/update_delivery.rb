module Gateway
  module Shippify
    module Webhooks
      class UpdateDelivery
        prepend Service::Base

        def initialize(delivery, delivery_gateway_id)
          @delivery = delivery
          @trip = @delivery.trip
          @shippify_delivery_id = delivery_gateway_id
          @trip_data = get_trip_data
        end

        def call
          return if errors.any?

          update_local_delivery
        end

        private

        def update_local_delivery
          begin
            Delivery.transaction do
              service = ::UpdateDelivery.call(@delivery, { status: deliveries_status })

              @trip.shipper = load_shipper if %w(assigned).include?(deliveries_status)
              @trip.shipper = nil if %w(processing broadcasting).include?(deliveries_status)

              @trip.status = deliveries_status
              @trip.save!

              if service.success?
                return service.result
              else
                errors.add_multiple_errors( service.errors )
                raise Service::Error.new(self)
              end
            end
          rescue Service::Error, ActiveRecord::RecordInvalid => e
            return errors.add_multiple_errors( exception_errors(e, @trip) ) && nil
          end
          nil
        end

        def exception_errors(exception, trip)
          exception.is_a?(Service::Error) ? exception.service.errors : trip.errors.messages
        end

        def shippify_delivery_id
          @shippify_delivery_id
        end

        def get_trip_data
          response = ::Shippify::Dash.client.trip(id: shippify_delivery_id)
          data = response['payload'].fetch('data', {})

          if trip_data = data['route']
            trip_data
          else
            errors.add(:type, I18n.t("services.gateway.shippify.update_delivery.trip_data.missing_or_invalid", id: shippify_delivery_id)) && nil
          end
        end

        def deliveries_data
          return @deliveries_data if defined?(@deliveries_data)

          @deliveries_data = @trip_data.delete("deliveries") || []
        end

        def courier_data
          return @courier_data if defined?(@courier_data)

          @courier_data = @trip_data.delete("courier") || {}
        end

        def deliveries_status
          @deliveries_status ||= deliveries_data.map{ |delivery| delivery['status'] }.uniq.last
        end

        def load_shipper
          Shipper.find_by(gateway: 'Shippify', gateway_id: courier_data['id'])
        end

      end
    end
  end
end
