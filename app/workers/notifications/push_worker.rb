module Notifications
  class PushWorker
    include Sidekiq::Worker
    sidekiq_options queue: :high_priority

    def perform(assignments_ids) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      logger.info "Sending push notification for #{assignments_ids.inspect}"
      @assignments = TripAssignment.preload(:shipper, :trip).where(id: assignments_ids)
      logger.info "Found #{@assignments.ids.inspect}"

      @assignments.each do |assignment|
        @shipper = assignment.shipper

        logger.info "About to evaluate if the shipper should receive push #{@shipper.id}"
        logger.info "#{@shipper.devices.inspect}"
        if (devices = @shipper.devices[:android]) && (@trip = assignment.trip)
          logger.info "Shipper should receive push #{@shipper.id}"
          disabled_devices = []
          notification_data = devices.keys.compact.map do |device_token|
            begin
              if notification = Notification.push(device_token, message(assignment), { trip_id: @trip.id })
                {
                  device: device_token,
                  message_id: notification.message_id
                }
              end
            rescue Notification::Error => e
              disabled_devices << device_token if e.cause.is_a?(Aws::SNS::Errors::EndpointDisabled)
              Rollbar.error(e, device_token: device_token, assignment: assignment.id) if defined?(Rollbar)
              nil
            end
          end.compact

          if notification_data.present?
            assignment.update!(notification_payload: notification_data, notified_at: Time.current)
          end

          if disabled_devices.present?
            logger.info "Disabling devices #{disabled_devices.inspect}"
            PurgeDisabledDevicesWorker.perform_async(@shipper.id, disabled_devices)
          end

        end
      end
    end

    private

    def message(assignment)
      I18n.t("push.notification.messages.#{assignment.state}")
    end

  end
end
