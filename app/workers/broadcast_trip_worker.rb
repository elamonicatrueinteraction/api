class BroadcastTripWorker
  include Sidekiq::Worker
  sidekiq_options queue: :high_priority

  def perform(trip_id)
    trip = Trip.find(trip_id)

    BroadcastTrip.call(trip, true)
  end

end
