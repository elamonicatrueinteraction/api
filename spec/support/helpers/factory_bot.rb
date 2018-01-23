module FactoryBot
  module Syntax
    module Methods

      def location_data(id, address, schedule = {})
        {
          place: place_name(address),
          delivery_id: id,
          schedule: schedule,
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
