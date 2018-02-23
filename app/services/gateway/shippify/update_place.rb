module Gateway
  module Shippify
    class UpdatePlace
      prepend Service::Base
      include Support::Place

      def initialize(address)
        @address = address
        @institution = address.institution
        begin
          @place = ::Shippify::Api::Place.new( shippify_id )
        rescue ::Shippify::Api::ArgumentError => e
          errors.add(:exception, e.message )
        end
      end

      def call
        return if errors.any?

        update_place
      end

      private

      def update_place
        @updated_place = @place.update( place_params(@address, @institution) )

        return @updated_place if @updated_place

        errors.add(:error, I18n.t('services.gateway.shippify.update_place.error', id: @place.id )) && nil
      end

      def shippify_id
        return unless @address.gateway == 'Shippify'

        @address.gateway_id
      end

    end
  end
end
