class PauseTrip
  prepend Service::Base

  def initialize(trip, raise_error = false)
    @trip = trip
    @dispatch = TripDispatch.new(@trip)
    @raise_error = raise_error
  end

  def call
    pause_trip
  end

  private

  def pause_trip
    pause = @dispatch.pause!

    return pause.trip if pause.success?

    errors.add_multiple_errors( pause.errors )

    @raise_error ? (raise Service::Error.new(self)) : (return nil)
  end
end
