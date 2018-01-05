module Gateway
  module Shippify
    class CreateVehicle
      prepend Service::Base
      include Support::Vehicle

      def initialize(vehicle)
        @vehicle = vehicle
        @shipper = @vehicle.shipper
        begin
          @shippify_shipper = ::Shippify::Dash::Shipper.new( shipper_shippify_id )
        rescue ::Shippify::Dash::ArgumentError => e
          errors.add(:exception, e.message )
        end
      end

      def call
        return if errors.any?

        create_vehicle
      end

      private

      def create_vehicle
        @updated_shippify_shipper = @shippify_shipper.create_vehicle( vehicle_params )

        if @updated_shippify_shipper

          @shippify_shipper = ::Shippify::Dash::Shipper.new( shipper_shippify_id )
          @vehicle.capacity   = @shippify_shipper.raw_data['capacity']
          @vehicle.gateway_id = @shippify_shipper.raw_data['vehicle_id']

          unless @vehicle.save
            errors.add_multiple_errors(@vehicle.errors.messages)
          end

          return @updated_shippify_shipper
        end

        errors.add(:error, I18n.t('services.gateway.shippify.create_vehicle.error', id: @vehicle.id )) && nil
      end

    end
  end
end
