module Gateway
  module Shippify
    class DeliveryCreateWorker
      include Sidekiq::Worker

      def perform(trip_id)
        if trip = Trip.find_by(id: trip_id)
          service = Gateway::Shippify::CreateDelivery.call(trip)

          unless service.success?
            raise StandardError.new(service.errors)
          end
        end
      end

    end
  end
end
