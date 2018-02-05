module Gateway
  module Shippify
    class VehicleWorker
      include Sidekiq::Worker

      class InvalidAction < StandardError
        attr_reader :action, :vehicle

        def initialize(action, vehicle)
          @action = action
          @vehicle = vehicle
        end
      end

      def perform(vehicle_id, action)
        action = action.to_s.downcase

        if vehicle = Vehicle.find_by(id: vehicle_id)
          raise InvalidAction.new(action, vehicle) unless valid_action?(action)

          service = service_class(action).call(vehicle)

          unless service.success?
            # I'm doing this because I don not want to retry tasks that despite they have
            # error messages the result is there. This is the case for the CreatePlace service
            unless service.result
              raise StandardError.new(service.errors)
            end
          end
        end
      end

      private

      def service_class(action)
        case action
        when 'create' then Gateway::Shippify::CreateVehicle
        when 'update' then Gateway::Shippify::UpdateVehicle
        end
      end

      def valid_action?(action)
        %w(create update).include?(action)
      end

    end
  end
end
