module Gateway
  module Shippify
    class PlaceWorker
      include Sidekiq::Worker

      class InvalidAction < StandardError
        attr_reader :action, :address

        def initialize(action, address)
          @action = action
          @address = address
        end
      end

      def perform(address_id, action)
        action = action.to_s.downcase

        if address = Address.find_by(id: address_id)
          raise InvalidAction.new(action, address) unless valid_action?(action)

          service = service_class(action).call(address)

          unless service.success?
            # Raise and Exception but not retry if there is something in the result
            # because Sidekiq seems to only retry if the raised exception inherit from
            # StandardError.
            # The service will have something in the result in the CreatePlace service
            # if the Shippify save succeed but the update_attribute in the Address doesn't
            raise Exception.new(service.errors) if service.result

            raise StandardError.new(service.errors)
          end
        end
      end

      private

      def service_class(action)
        case action
        when 'create' then Gateway::Shippify::CreatePlace
        when 'update' then Gateway::Shippify::UpdatePlace
        end
      end

      def valid_action?(action)
        %w(create update).include?(action)
      end

    end
  end
end
