class UpdateTrip
  prepend Service::Base
  include Service::Support::Trip

  def initialize(trip, allowed_params, current_user_id)
    @trip = trip
    @allowed_params = allowed_params
    @shipper = load_shipper(@allowed_params.delete(:shipper_id)) if @allowed_params[:shipper_id].present?
    @create_audit = Audits::CreateAudit.new(model: Audit::Models::TRIP, field: 'amount')
    @current_user_id = current_user_id
  end

  def call
    return if errors.any?

    update_trip
  end

  private

  def update_trip

    if @trip.status.present?
      update_amount
    else
      update_trip_info
    end
  end

  def update_amount

    original_amount = @trip.amount
    amount = @allowed_params[:amount]
    errors_found = {}
    if original_amount > amount
      errors_found[:amount] = "El monto nuevo: #{amount} no puede se mas bajo que el anterior #{original_amount}"
    end
    if errors_found.empty?
      @trip.update!({amount: amount})
      if amount != original_amount
        @create_audit.create(audited: @trip, original_value: original_amount,
                             new_value: amount, user_id: @current_user_id)
      end
      @trip
    else
      errors_found.each { |k, v| errors.add(k, v) }
    end
  end

  def update_trip_info

    old_amount = @trip.amount
    params = trip_params
    @trip.assign_attributes(params)

    if !@trip.changed? || @trip.save
      amount = params[:amount]
      if !amount.nil? && amount != old_amount
        @create_audit.create(audited: @trip, original_value: old_amount, new_value: amount, user_id: @current_user_id)
      end

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
        pickup_schedule = @allowed_params[:pickup_schedule].presence || @trip.pickup_window
        @allowed_params.delete(:pickup_schedule)

        dropoff_schedule = @allowed_params[:dropoff_schedule].presence || @trip.dropoff_window
        @allowed_params.delete(:dropoff_schedule)

        _hash[:steps] = steps_data(
          @trip.deliveries,
          pickup_schedule,
          dropoff_schedule
        )
      end
    end
  end

end
