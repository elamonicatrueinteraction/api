module Service
  module Support
    module Trip

      private

      def load_shipper(id)
        if shipper = Shipper.find_by(id: id)
          shipper
        else
          errors.add(:type, I18n.t("services.create_trip.shipper.missing_or_invalid", id: id)) && nil
        end
      end

      def steps_data(deliveries, pickup_schedule, dropoff_schedule)

        gmaps = GoogleMapsService::Client.new

        o = deliveries.map {|d| {lng: d.origin_gps_coordinates.x, lat: d.origin_gps_coordinates.y}}.uniq

        if (o.count == 1)
          d = deliveries.map {|d| {lng: d.destination_gps_coordinates.x, lat: d.destination_gps_coordinates.y}}.uniq
          waypoints = d + (o - [o.first])
          route = gmaps.directions( o.first, o.first, waypoints: waypoints.reverse, mode: 'driving', alternatives: false, units: 'metric', optimize_waypoints: true)
          if (route.count > 0)
            r = route.first
            deliveries_sorted = []
            r[:waypoint_order].each_with_index { |order, index| deliveries_sorted[order] =  deliveries[index]}
            q = r[:legs].map {|l| {distance: l[:distance], duration: l[:duration]} }
            total_distance = q.map {|d| d[:distance][:value]}.sum/1000.to_f # in KM
            total_duration = q.map {|d| d[:duration][:value]}.sum/60.to_f # in MINUTES

            deliveries = deliveries_sorted
          end

        end

        # TO-DO: We need to rethink this because this should be replaced by a logic of an optimize route.
        # for now we are routing all the pickups first and then all the dropoff, no optimization applied
        x = deliveries.group_by(&:origin_id).map do |(_origin_id, grouped_deliveries)|
          compact_steps(grouped_deliveries, 'pickup', pickup_schedule)
        end + deliveries.group_by(&:destination_id).map do |(_destination_id, grouped_deliveries)|
          compact_steps(grouped_deliveries, 'dropoff', dropoff_schedule)
        end



        x
      end

      def compact_steps(grouped_deliveries, action, pickup_schedule)
        grouped_deliveries.inject({}) do |_pickups, delivery|
          if _pickups.keys.empty?
            _pickups = step_info(delivery, action, pickup_schedule)
          else
            _pickups[:delivery_id] << delivery.id
          end
          _pickups
        end
      end

      def step_info(delivery, action, schedule)
        {
          delivery_id: [delivery.id],
          action: action,
          schedule: schedule_param(schedule),
          institution: action == 'pickup' ? delivery.giver : delivery.receiver,
          address: action == 'pickup' ? delivery.origin : delivery.destination
        }
      end

      def schedule_param(schedule = {})
        now = Time.current
        {
          start: ( schedule[:start].present? ? schedule[:start] : now ),
          end: ( schedule[:end].present? ? schedule[:end] : (now + 1.hour) )
        }
      end

    end
  end
end
