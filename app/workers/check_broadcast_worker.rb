class CheckBroadcastWorker
  include Sidekiq::Worker
  sidekiq_options queue: :high_priority

  def perform(assignments_ids)
    assignments = TripAssignment.preload(:shipper, :trip).where(id: assignments_ids)

    assignments.each do |assignment|
      next if assignment.closed?

      now = Time.current
      TripAssignment.transaction do
        # Pessimistic Locking in order to prevent race-conditions
        assignment.lock!
        assignment.update!(closed_at: now)
      end
    end

    trips = assignments.flat_map(:trip).uniq
    trips.each do |trip|
      next unless [nil, 'waiting_shipper'].include?(trip.status)

      BroadcastTripWorker.perform_async(trip.id)
    end

  end

end
