class DestroyTrip
  prepend Service::Base

  def initialize(trip)
    @trip = trip
  end

  def call
    destroy_trip
  end

  private

  def destroy_trip
    return unless can_detroy_trip?

    @trip.destroy ? @trip : errors.add_multiple_errors(@trip.errors.full_messages) && nil
  end

  def can_detroy_trip?
    if @trip.status.present? && @trip.gateway_setup
      errors.add(:type, I18n.t("services.destroy_trip.trip_on_going")) && nil
      return false
    end
    true
  end

end
