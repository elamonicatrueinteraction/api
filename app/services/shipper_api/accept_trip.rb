module ShipperApi
  class AcceptTrip
    prepend Service::Base

    def initialize(shipper, trip)
      @trip = trip
      @shipper = shipper
      @dispatch = TripDispatch.new(@trip, @shipper)
    end

    def call
      accept_trip
    end

    private

    def accept_trip
      assignment = @dispatch.take!

      return assignment.trip if assignment.success?

      errors.add_multiple_errors( assignment.errors ) & nil
    end
  end
end
