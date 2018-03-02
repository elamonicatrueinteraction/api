module Gateway
  module Shippify
    module Webhooks
      class UpdateDelivery
        prepend Service::Base

        def initialize(delivery, delivery_gateway_id)
          @delivery = delivery
          @trip = delivery.trip
          @shippify_delivery_id = delivery_gateway_id
          @trip_data = get_trip_data
        end

        def call
          return if errors.any?

          update_local_delivery
        end

        private

        def update_local_delivery
          begin
            Delivery.transaction do
              service = ::UpdateDelivery.call(@delivery, { status: deliveries_status })

              @trip.shipper = load_shipper if %w(assigned).include?(deliveries_status)
              @trip.shipper = nil if %w(processing broadcasting).include?(deliveries_status)

              if deliveries_dates_changed?
                @trip.steps = @new_steps_dates
              end

              @trip.status = deliveries_status
              @trip.save!

              if service.success?
                return service.result
              else
                errors.add_multiple_errors( service.errors )
                raise Service::Error.new(self)
              end
            end
          rescue Service::Error, ActiveRecord::RecordInvalid => e
            return errors.add_multiple_errors( exception_errors(e, @trip) ) && nil
          end
          nil
        end

        def exception_errors(exception, trip)
          exception.is_a?(Service::Error) ? exception.service.errors : trip.errors.messages
        end

        def shippify_delivery_id
          @shippify_delivery_id
        end

        def get_trip_data
          response = ::Shippify::Dash.client.trip(id: shippify_delivery_id)
          data = response['payload'].fetch('data', {})

          if trip_data = data['route']
            trip_data
          else
            errors.add(:type, I18n.t("services.gateway.shippify.update_delivery.trip_data.missing_or_invalid", id: shippify_delivery_id)) && nil
          end
        end

        def deliveries_data
          return @deliveries_data if defined?(@deliveries_data)

          @deliveries_data = @trip_data.delete("deliveries") || []
        end

        def courier_data
          return @courier_data if defined?(@courier_data)

          @courier_data = @trip_data.delete("courier") || {}
        end

        def deliveries_status
          @deliveries_status ||= deliveries_data.map{ |delivery| delivery['status'] }.uniq.last
        end

        def load_shipper
          Shipper.find_by(gateway: 'Shippify', gateway_id: courier_data['id'])
        end

        # TO-DO: This logic looks very ugly and like a monkeypatch
        # I'm leaving like this because is not going to be here for ever
        def deliveries_dates_changed?
          changed = false
          steps = @trip.steps
          @new_steps_dates = steps.clone

          actions = %w(pickup dropoff)
          deliveries_data.each do |delivery_data|
            if reference_id = delivery_data['referenceId']
              actions.each do |action|
                time_window = delivery_data[action]['timeWindow']
                step_schedule = step_schedule(steps, action, reference_id)
                if time_window != step_schedule
                  @new_steps_dates = @new_steps_dates.map do |new_step|
                    if new_step['action'] == action && new_step['delivery_id'].to_s == reference_id.to_s
                      new_step['schedule'] = time_window
                    end
                    new_step
                  end
                  changed = true
                end
              end
            end
          end

          changed
        end

        def step_schedule(steps, action, reference_id)
          step = steps.detect{|step| step['action'] == action && step['delivery_id'].to_s == reference_id.to_s } || {}
          step['schedule']
        end

      end
    end
  end
end
