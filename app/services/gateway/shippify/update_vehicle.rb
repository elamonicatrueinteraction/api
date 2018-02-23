module Gateway
  module Shippify
    class UpdateVehicle
      prepend Service::Base
      include Support::Vehicle

      def initialize(vehicle)
        @vehicle = vehicle
        @shipper = @vehicle.shipper
        @shippify_vehicle_id = get_vehicle_shippify_id

        begin
          @shippify_shipper = ::Shippify::Dash::Shipper.new( shipper_shippify_id )
        rescue ::Shippify::Dash::ArgumentError => e
          errors.add(:exception, e.message )
        end
      end

      def call
        return if errors.any?

        update_vehicle
      end

      private

      def update_vehicle
        @updated_shippify_shipper = @shippify_shipper.update_vehicle( vehicle_params, @shippify_vehicle_id )

        return @updated_shippify_shipper if @updated_shippify_shipper

        errors.add(:error, I18n.t('services.gateway.shippify.update_vehicle.errors.general', id: @shippify_vehicle_id )) && nil
      end

      def get_vehicle_shippify_id
        id = @vehicle.gateway_id

        return id if id

        errors.add(:error, I18n.t('services.gateway.shippify.update_vehicle.errors.shippify_vehicle_id', id: @vehicle.id )) && nil
      end

    end
  end
end
