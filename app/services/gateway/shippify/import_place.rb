module Gateway
  module Shippify
    class ImportPlace
      prepend Service::Base

      def initialize(place_data)
        @place_data = place_data
      end

      def call
        import_place
      end

      private

      def import_place
        return if address.persisted?

        breakdown_address_parts

        address.gps_coordinates = gps_coordinates
        address.lookup = @place_data['address']
        address.street_1 = @street_address
        address.zip_code = @zip_code
        address.city = @city
        address.state = @state
        address.country = @country
        address.contact_name = contact['name']
        address.contact_cellphone = contact['phone'] || contact['phonenumber']
        address.contact_email = contact['email']
        address.notes = @place_data['instructions']

        address.institution = address_institution if @place_data['name'].present?

        address.gateway = 'Shippify'
        address.gateway_id = shippify_place_id
        address.gateway_data = {
          fetched_at: Time.now,
          data: @place_data
        }

        return address if address.save
        nil
      end

      def address
        return @address if defined?(@address)

        @address = if shippify_place_id
          Address.find_by(gateway: 'Shippify', gateway_id: shippify_place_id) || Address.new
        else
          Address.find_by(gps_coordinates: gps_coordinates) || Address.new
        end
      end

      def shippify_place_id
        @shippify_place_id ||= @place_data['id']
      end

      def gps_coordinates
        @gps_coordinates ||= "POINT (#{longitude} #{latitude})"
      end

      def latitude
        @place_data['lat'] || @place_data['latitude']
      end

      def longitude
        @place_data['lng'] || @place_data['longitude']
      end

      def breakdown_address_parts
        parts = @place_data['address'].split(',').map(&:strip)
        @country = parts.pop
        @state = parts.pop
        city_and_zip = parts.pop.split(' ')
        if city_and_zip.length >= 2
          @zip_code = city_and_zip.shift
        end
        @city = city_and_zip.join(' ')
        @street_address = parts.pop
      end

      def contact
        @contact ||= @place_data.fetch('contact', {})
      end

      def address_institution
        institution_params = {
          "name" => @place_data['name'],
          "type" => 'Institutions::Organization',
          "uid_type" => 'CUIT'
        }

        Institution.new(institution_params)
      end

    end
  end
end
