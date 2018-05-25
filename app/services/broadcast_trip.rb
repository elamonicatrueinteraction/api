class BroadcastTrip
  prepend Service::Base

  def initialize(trip, within_transaction = false)
    @trip = trip
    @dispatch = TripDispatch.new(@trip)
    @within_transaction = within_transaction
  end

  def call
    broadcast_trip
  end

  private

  def broadcast_trip
    broadcast = @dispatch.broadcast!

    return broadcast.trip if broadcast.success?

    errors.add_multiple_errors( broadcast.errors )

    @within_transaction ? (raise Service::Error.new(self)) : (return nil)
  end
end
