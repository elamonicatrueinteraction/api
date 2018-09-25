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

    begin
      Trip.transaction do
        deliveries = @trip.deliveries

        deliveries.map do |delivery|
          delivery.update!(status: 'processing')
        end
        @trip.destroy!
      end
    rescue ActiveRecord::RecordNotDestroyed, ActiveRecord::RecordInvalid => e
      return errors.add_multiple_errors( exception_errors(e) ) && nil
    end

    @trip
  end

  def can_detroy_trip?
    if @trip.status.present?
      errors.add(:type, I18n.t("services.destroy_trip.trip_on_going")) && nil
      return false
    end
    true
  end

end
