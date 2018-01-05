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
