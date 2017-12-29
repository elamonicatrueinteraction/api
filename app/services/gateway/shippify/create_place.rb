module Gateway
  module Shippify
    class CreatePlace
      prepend Service::Base
      include Support::Place

      def initialize(address)
        @address = address
        @institution = address.institution
      end

      def call
        create_place
      end

      private

      def create_place
        @place = ::Shippify::Api::Place.create( place_params(@address, @institution) )

        if @place
          @address.assign_attributes({ gateway: 'Shippify', gateway_id: @place.id })

          unless @address.save
            errors.add_multiple_errors(@address.errors.messages)
          end

          return @place
        end

        errors.add(:error, I18n.t('services.gateway.shippify.create_place.error', id: @address.id )) && nil
      end

    end
  end
end
