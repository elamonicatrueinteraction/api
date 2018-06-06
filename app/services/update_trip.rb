class UpdateTrip
  prepend Service::Base
  include Service::Support::Trip

  def initialize(trip, allowed_params)
    @trip = trip
    @allowed_params = allowed_params
  end

  def call
    update_trip
  end

  private

  def update_trip
    @trip.assign_attributes( trip_params )

    return if errors.any?

    return @trip if @trip.save

    errors.add_multiple_errors(@trip.errors.messages) && nil
  end

  def trip_params
    @allowed_params.tap do |_hash|
      if _hash[:shipper_id].present? && (shipper = load_shipper(@allowed_params.delete(:shipper_id)))
        _hash[:shipper] = shipper
      end
      @allowed_params.delete(:amount) if @allowed_params[:amount].blank?
    end
  end

end
