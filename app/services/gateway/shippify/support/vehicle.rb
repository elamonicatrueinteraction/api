module Gateway
  module Shippify
    module Support
      module Vehicle

        private

        def shipper_shippify_id
          return unless @shipper.gateway == 'Shippify'

          @shipper.gateway_id
        end

        def vehicle_params
          {
            model: @vehicle.year,
            type: vehicle_type,
            capacity: 'Truck', # This is a truck by default, we should change this if we need to control it
          }.tap do |_hash|
            if license_plate_verification
              _hash[:license_plate] = license_plate_verification.information[:number]
            end
          end
        end

        def vehicle_type
          [
            @vehicle.brand,
            @vehicle.model
          ].compact.join(' - ')
        end

        def license_plate_verification
          @license_plate_verification ||= @vehicle.verifications.detect{ |v| v.type == 'license_plate' }
        end

      end
    end
  end
end
