module Gateway
  module Shippify
    class UpdateShipper
      prepend Service::Base

      def initialize(shipper)
        @shipper = shipper
        begin
          @shippify_shipper = ::Shippify::Dash::Shipper.new( shippify_id )
        rescue ::Shippify::Dash::ArgumentError => e
          errors.add(:exception, e.message )
        end
      end

      def call
        return if errors.any?

        update_shipper
      end

      private

      def update_shipper
        @updated_shippify_shipper = @shippify_shipper.update( shipper_params )

        return @updated_shippify_shipper if @updated_shippify_shipper

        errors.add(:error, I18n.t('services.gateway.shippify.update_shipper.error', id: @shippify_shipper.id )) && nil
      end

      def shippify_id
        return unless @shipper.gateway == 'Shippify'

        @shipper.gateway_id
      end

      def shipper_params
        {
          first_name: @shipper.first_name,
          last_name: @shipper.last_name,
          doc_id: @shipper.national_ids['dni'],
          mobile: @shipper.phone_num,
          email: @shipper.email
        }
      end

    end
  end
end
