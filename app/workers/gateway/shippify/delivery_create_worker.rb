module Gateway
  module Shippify
    class DeliveryCreateWorker
      include Sidekiq::Worker

      def perform(trip_id)
        if trip = Trip.find_by(id: trip_id)
          service = Gateway::Shippify::CreateDelivery.call(trip)

          if service.success?
            # TO-DO: Pure frustration on all the following lines! seriously I wanna cry!
            trip = service.result
            if trip.shipper
              Gateway::Shippify::AssignRoute.call(trip)
            else
              Gateway::Shippify::BroadcastRoute.call(trip)
            end
          else
            # I'm doing this because I don not want to retry tasks that despite they have
            # error messages, the result is there. This is the case for the CreateDelivery service
            unless service.result
              raise StandardError.new(service.errors)
            end
          end
        end
      end

    end
  end
end
