module Service
  module Support
    module Delivery

      private

      def load_address(action, id)
        if address = ::Address.find_by(id: id)
          address
        else
          id = id.blank? ? '(empty)' : id
          errors.add(:type, I18n.t("services.create_delivery.#{action}.missing_or_invalid", id: id)) && nil
        end
      end

      def params_status_or_default(params_status, actual_status = nil)
        return params_status if params_status && ::Delivery.valid_status.include?(params_status.to_s)

        actual_status ? actual_status : ::Delivery.default_status
      end

      def location_data(address)
        {
          place: place_name(address),
          address: {
            id: address.id,
            telephone: address.telephone,
            street_1: address.street_1,
            street_2: address.street_2,
            zip_code: address.zip_code,
            city: address.city,
            state: address.state,
            country: address.country
          },
          latlng: address.latlng,
          open_hours: address.open_hours,
          notes: address.notes,
          contact: contact_data(address)
        }
      end

      def place_name(address)
        address.institution ? address.institution.name : address.lookup
      end

      def contact_data(address)
        {
          name: address.contact_name,
          cellphone: address.contact_cellphone,
          email: address.contact_email
        }
      end

    end
  end
end
