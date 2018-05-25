module Notifications
  class PushWorker
    include Sidekiq::Worker

    def perform(assignment_id)
      @assignment = TripAssignment.find_by(id: assignment_id)
      @shipper = @assignment.shipper

      if (devices = @shipper.devices[:android]) && (@trip = @assignment.trip)
        notification_data = devices.keys.map do |device_token|
          content = { trip: { id: @trip.id } }
          if notification = Notification.push(device_token, '¡Hay un viaje para aceptar!', content)
            {
              device: device_token,
              content: content,
              message_id: notification.message_id
            }
          end
        end.compact

        raise StandardError.new(self) if notification_data.blank?

        @assignment.update!(notification_payload: notification_data, notified_at: Time.current)
      end

    end

  end
end
