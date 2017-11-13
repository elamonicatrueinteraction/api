module Gateway
  module Shippify
    class ImportShipper
      prepend Service::Base

      def initialize(shippify_data = {})
        @shippify_data = shippify_data.each_with_object({}){ |(k,_), _hash| _hash[k.downcase] = _ }
      end

      def call
        import_shipper
      end

      private

      def import_shipper
        return if shipper.persisted?

        if shipper_name_parts.length > 1
          shipper.last_name = shipper_name_parts.slice!(-1)
          shipper.first_name = shipper_name_parts.join(' ')
        else
          shipper.first_name = @shippify_data['name'].strip
        end
        shipper.email = @shippify_data['email']
        shipper.phone_num = @shippify_data['phone']
        shipper.national_ids = shipper_national_id
        shipper.active = @shippify_data['status'] == 3
        shipper.verified = @shippify_data['is_documentation_verified'] == 1
        shipper.vehicles = [ shipper_vehicle ]
        shipper.gateway = 'Shippify'
        shipper.gateway_id = shippify_shipper_id
        shipper.data = {
          data: @shippify_data,
          details: shipper_details,
          fetched_at: Time.now
        }

        return shipper if shipper.save
        nil
      end

      def shipper
        return @shipper if defined?(@shipper)

        @shipper = Shipper.find_by(gateway: 'Shippify', gateway_id: shippify_shipper_id) || Shipper.new
      end

      def shipper_details
        return @shipper_details if defined?(@shipper_details)

        data = ::Shippify::Dash.client.shipper(id: shippify_shipper_id)["data"][0] || {}
        @shipper_details = data.each_with_object({}){ |(k,_), _hash| _hash[k.downcase] = _ }
      end

      def shippify_shipper_id
        @shippify_shipper_id ||= @shippify_data['id']
      end

      def shipper_name_parts
        @shipper_name_parts ||= @shippify_data['name'].split(' ')
      end

      def shipper_national_id
        return {} unless doc_id = shipper_details['doc_id'].presence

        {
          'dni' => doc_id
        }
      end

      def shipper_vehicle
        return {} unless vehicle_type = shipper_details['vehicle_type'].presence

        {
          "type" => vehicle_type,
          "license_plate" => shipper_details['license_plate'],
          "year" => shipper_details['vehicle_model'],
          "vehicle_id" => shipper_details['vehicle_id'],
          "capacity" => shipper_details['capacity']
        }
      end

    end
  end
end
