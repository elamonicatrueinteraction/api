module Gateway
  module Shippify
    module Support
      module Place

        private

        def place_params(address, institution)
          lat, lng = address.latlng.split(',')

          {
            address: address.lookup_address,
            lat: lat,
            lng: lng,
            name: institution.name,
            instructions: address.notes,
            contact: {
              name: address.contact_name,
              email: address.contact_email,
              phone: address.contact_cellphone
            }
          }
        end

      end
    end
  end
end
