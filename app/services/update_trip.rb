class UpdateTrip
  prepend Service::Base
  include Service::Support::Trip

  def initialize(trip, allowed_params)
    @trip = trip
    @allowed_params = allowed_params
    @shipper = load_shipper(@allowed_params.delete(:shipper_id)) if @allowed_params[:shipper_id].present?
  end

  def call
    return if errors.any?

    update_trip
  end

  private

  def update_trip
    return unless can_update_trip?

    @trip.assign_attributes( trip_params )

    if (!@trip.changed?) || @trip.save
      # TO-DO: We should think better where and how we need to implement this logic
      AssignTrip.call(@trip, @shipper) if @shipper

      return @trip
    end

    errors.add_multiple_errors(@trip.errors.messages) && nil
  end

  def trip_params
    @allowed_params.tap do |_hash|
      @allowed_params.delete(:amount) if @allowed_params[:amount].blank?
      @allowed_params.delete(:comments) if @allowed_params[:comments].blank?

      if @allowed_params[:pickup_schedule].present? || @allowed_params[:dropoff_schedule].present?
        pickup_schedule = if @allowed_params[:pickup_schedule].present?
          @allowed_params[:pickup_schedule]
        else
          @trip.pickup_window
        end
        @allowed_params.delete(:pickup_schedule)

        dropoff_schedule = if @allowed_params[:dropoff_schedule].present?
          @allowed_params[:dropoff_schedule]
        else
          @trip.dropoff_window
        end
        @allowed_params.delete(:dropoff_schedule)

        _hash[:steps] = steps_data(
          @trip.deliveries,
          pickup_schedule,
          dropoff_schedule
        )
      end
    end
  end

  def can_update_trip?
    if @trip.status.present?
      errors.add(:type, I18n.t("services.update_trip.trip_on_going", status: @trip.status)) && nil
      return false
    end
    true
  end

end
