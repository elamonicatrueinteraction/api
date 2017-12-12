module Gateway
  module Shippify
    class ImportTrip
      prepend Service::Base

      def initialize(trip_gateway_id)
        @shippify_trip_id = trip_gateway_id
        @trip_data = get_trip_data
      end

      def call
        return if errors.any?

        import_trip
      end

      private

      def import_trip
        return if trip_exist?

        begin
          Trip.transaction do
            shipper     = grab_shipper_or_create
            deliveries  = grab_deliveries_or_create

            orders_ids = deliveries.flat_map(&:order_id).uniq

            create_trip_params = {
              orders_ids: orders_ids,
              status: @trip_data['status'],
              pickup_schedule: pickup_schedule,
              dropoff_schedule: dropoff_schedule,
              gateway: 'Shippify',
              gateway_id: shippify_trip_id,
              gateway_data: @trip_data,
            }.tap do |_hash|
              _hash[:shipper_id] = shipper.id if shipper
            end

            service = ::CreateTrip.call(create_trip_params)
            if service.success?
              return service.result
            else
              errors.add_multiple_errors( service.errors )
              raise Service::Error.new(self)
            end
          end
        rescue Service::Error => e
          return errors.add_multiple_errors(e.service.errors) && nil
        end
        nil
      end

      def shippify_trip_id
        @shippify_trip_id
      end

      def get_trip_data
        response = ::Shippify::Dash.client.trip(id: shippify_trip_id)
        data = response['payload'].fetch('data', {})

        if trip_data = data['route']
          trip_data
        else
          errors.add(:type, I18n.t("services.gateway.shippify.import_trip.trip_data.missing_or_invalid", id: shippify_trip_id)) && nil
        end
      end

      def trip_exist?
        if Trip.find_by(gateway: 'Shippify', gateway_id: shippify_trip_id)
          errors.add(:type, I18n.t("services.gateway.shippify.import_trip.trip_data.already_exist", id: shippify_trip_id))
          return true
        end
        false
      end

      def pickup_schedule
        delivery = deliveries_data.first || {}

        pickup = delivery.fetch('pickup', {})
        schedule = pickup.fetch('timeWindow', {})
        {
          start: schedule['start'],
          end: schedule['end']
        }
      end

      def dropoff_schedule
        delivery = deliveries_data.first || {}

        dropoff = delivery.fetch('dropoff', {})
        schedule = dropoff.fetch('timeWindow', {})
        {
          start: schedule['start'],
          end: schedule['end']
        }
      end

      def grab_shipper_or_create
        shipper_data = @trip_data.delete("courier") || {}

        return if shipper_data.empty?

        if shipper = Shipper.find_by(gateway: 'Shippify', gateway_id: shipper_data['id'])
          shipper
        else
          service = Gateway::Shippify::ImportShipper.call(shipper_data)

          if service.success?
            service.result
          else
            errors.add_multiple_errors( service.errors )
            raise Service::Error.new(self)
          end
        end
      end

      def deliveries_data
        return @deliveries_data if defined?(@deliveries_data)

        @deliveries_data = @trip_data.delete("deliveries") || []
      end

      def grab_deliveries_or_create
        if deliveries_data.blank?
          errors.add(:type, I18n.t("services.gateway.shippify.import_trip.deliveries_data.missing_or_invalid"))
          raise Service::Error.new(self)
        end

        deliveries_data.flat_map do |delivery_data|
          if delivery = Delivery.find_by(gateway: 'Shippify', gateway_id: delivery_data['id'])
            return [ delivery ]
          end

          service = ::CreateOrder.call( order_params(delivery_data) )
          if service.success?
            order = service.result
            return order.deliveries
          else
            errors.add_multiple_errors( service.errors )
            raise Service::Error.new(self)
          end
        end
      end

      def order_params(delivery_data)
        origin = grab_or_create_address( delivery_data.fetch('pickup', {}) )
        destination = grab_or_create_address( delivery_data.fetch('dropoff', {}) )
        {
          origin_id: origin.id,
          destination_id: destination.id,
          status: delivery_data.fetch('status', nil),
          delivery_amount: delivery_data.fetch('fare', {})['service'],
          gateway: 'Shippify',
          gateway_id: delivery_data['id'],
          gateway_data: delivery_data
        }.tap do |_hash|
          if giver = origin.institution
            _hash[:giver_id] = giver.id
          end
          if receiver = origin.institution
            _hash[:receiver_id] = receiver.id
          end
          _hash[:packages] = []
          delivery_data.fetch('package', {})['contents'].each do |package_data|
            _hash[:packages] << {
              quantity: package_data['quantity'],
              description: package_data['name']
            }
          end
        end
      end

      def grab_or_create_address(address_data)
        place_data = address_data.fetch('location', {})

        if address = Address.find_by(gps_coordinates: "POINT (#{place_data['longitude']} #{place_data['latitude']})")
          return address
        end

        service = Gateway::Shippify::ImportPlace.call( place_data.merge('contact' => address_data.fetch('contact', {})) )
        if service.success?
          return service.result
        else
          errors.add_multiple_errors( service.errors )
          raise Service::Error.new(self)
        end
      end

    end
  end
end
