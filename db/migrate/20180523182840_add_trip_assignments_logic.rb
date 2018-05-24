class AddTripAssignmentsLogic < ActiveRecord::Migration[5.1]
  def up
    create_table :trip_assignments do |t|
      t.string  :state

      t.uuid  :trip_id, index: true
      t.uuid  :shipper_id, index: true

      t.datetime :created_at

      t.jsonb :notification_payload, default: {}
      t.datetime :notified_at

      t.datetime :closed_at
    end
    add_index :trip_assignments, [:trip_id, :shipper_id]
    add_index :trip_assignments, :notification_payload, using: :gin

    Trip.find_each do |trip|
      if trip.orders.all?{ |o| o.payments.blank? && o.deliveries.flat_map(&:payments).blank? }
        trip.orders.map(&:destroy)
        trip.destroy
      else
        if %w[completed dropped_off picked_up].include?(trip.status)
          if shipper = trip.shipper
            TripAssignment.create!(
              state: 'accepted',
              trip: trip,
              shipper: shipper,
              created_at: trip.created_at,
              closed_at: trip.created_at
            )
          end
          trip.update(status: 'completed')
        elsif %w[canceled client_canceled].include?(trip.status)
          trip.update(status: 'canceled', shipper: nil)
        end
      end
    end
  end

  def down
    drop_table :trip_assignments
  end

end
