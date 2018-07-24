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
        deliveries.each_with_object({ pickups: [], dropoffs: [] }) do |delivery, _steps|
          _steps[:pickups] << {
            delivery_id: delivery.id,
            action: 'pickup',
            schedule: schedule_param(pickup_schedule)
          }
          _steps[:dropoffs] << {
            delivery_id: delivery.id,
            action: 'dropoff',
            schedule: schedule_param(dropoff_schedule)
          }
        end.values.flatten
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
