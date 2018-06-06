class AssignTrip
  prepend Service::Base

  def initialize(trip, shipper, within_transaction = false)
    @trip = trip
    @shipper = shipper
    @dispatch = TripDispatch.new(@trip, @shipper)
    @within_transaction = within_transaction
  end

  def call
    assign_trip
  end

  private

  def assign_trip
    assignment = @dispatch.assign!

    return assignment.trip if assignment.success?

    errors.add_multiple_errors( assignment.errors )

    @within_transaction ? (raise Service::Error.new(self)) : (return nil)
  end
end
