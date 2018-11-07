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
        # TO-DO: We need to rethink this because this should be replaced by a logic of an optimize route.
        # for now we are routing all the pickups first and then all the dropoff, no optimization applied
        deliveries.group_by(&:origin_id).map do |(_origin_id, grouped_deliveries)|
          compact_steps(grouped_deliveries, 'pickup', pickup_schedule)
        end + deliveries.group_by(&:destination_id).map do |(_origin_id, grouped_deliveries)|
          compact_steps(grouped_deliveries, 'dropoff', dropoff_schedule)
        end
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
