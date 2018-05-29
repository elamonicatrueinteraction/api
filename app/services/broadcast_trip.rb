class BroadcastTrip
  prepend Service::Base

  def initialize(trip, raise_error = false)
    @trip = trip
    @dispatch = TripDispatch.new(@trip)
    @raise_error = raise_error
  end

  def call
    broadcast_trip
  end

  private

  def broadcast_trip
    broadcast = @dispatch.broadcast!

    return broadcast.trip if broadcast.success?

    errors.add_multiple_errors( broadcast.errors )

    @raise_error ? (raise Service::Error.new(self)) : (return nil)
  end
end
