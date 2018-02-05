module Gateway
  module Shippify
    class ShipperUpdateWorker
      include Sidekiq::Worker

      def perform(shipper_id)
        if shipper = Shipper.find_by(id: shipper_id)
          service = Gateway::Shippify::UpdateShipper.call(shipper)

          unless service.success?
            raise StandardError.new(service.errors)
          end
        end
      end

    end
  end
end
