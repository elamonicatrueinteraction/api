module Notifications
  class PushWorker
    include Sidekiq::Worker

    def perform(assignments_ids)
      @assignments = TripAssignment.preload(:shipper, :trip).where(id: assignments_ids)

      @assignments.each do |assignment|
        @shipper = assignment.shipper

        if (devices = @shipper.devices[:android]) && (@trip = assignment.trip)
          notification_data = devices.keys.map do |device_token|
            begin
              if notification = Notification.push(device_token, message(assignment))
                {
                  device: device_token,
                  content: content,
                  message_id: notification.message_id
                }
              end
            rescue Notification::Error => e
              Rollbar.info(e, device_token: device_token, assignment: assignment.id) if defined?(Rollbar)
              nil
            end
          end.compact

          if notification_data.present?
            assignment.update!(notification_payload: notification_data, notified_at: Time.current)
          end
        end
      end
    ensure
      CheckBroadcastWorker.perform_in(2.minutes, assignments_ids)
    end

    private

    def message(assignment)
      I18n.t("push.notification.messages.#{assignment.state}")
    end

  end
end
