class CreateTrip
  prepend Service::Base
  include Service::Support::Trip

  def initialize(allowed_params)
    @allowed_params = allowed_params
    @shipper = load_shipper(@allowed_params[:shipper_id]) if @allowed_params[:shipper_id]
    load_deliveries
  end

  def call
    return if errors.any?

    create_trip
  end

  private

  def load_deliveries
    if orders = Order.where(id: @allowed_params[:orders_ids])
      if orders.blank? || orders.any?{ |order| order.deliveries.blank? }
        return errors.add(:type, I18n.t("services.create_trip.deliveries.missing_or_invalid", id: @allowed_params[:orders_ids].join(', ')))
      end

      @deliveries = orders.flat_map(&:deliveries)
    else
      errors.add(:type, I18n.t("services.create_trip.order.missing_or_invalid", id: @allowed_params[:orders_ids].join(', ')))
    end
  end

  def create_trip
    @trip = Trip.new( trip_params )

    return if errors.any?

    begin
      Trip.transaction do
        @trip.save!

        @deliveries.each do |delivery|
          delivery.update!(trip: @trip)
        end
      end
    rescue Service::Error, ActiveRecord::RecordInvalid => e
      return errors.add(:exception, e.message ) && nil
    end
    # TO-DO: We should think better where and how we need to implement this logic
    AssignTrip.call(@trip, @shipper) if @shipper

    @trip
  end

  def trip_params
    {
      comments: @allowed_params[:comments],
      amount: @allowed_params[:amount] || 0.0,
      steps: steps_data
    }.tap do |_hash|
      _hash[:gateway] = @allowed_params[:gateway] if @allowed_params[:gateway]
      _hash[:gateway_id] = @allowed_params[:gateway_id] if @allowed_params[:gateway_id]
      _hash[:gateway_data] = @allowed_params[:gateway_data] if @allowed_params[:gateway_data]
    end
  end

  def steps_data
    # TO-DO: We need to rethink this because this should be replaced by a logic of an optimize route.
    # for now we are routing all the pickups first and then all the dropoff, no optimization applied
    @deliveries.each_with_object({ pickups: [], dropoffs: [] }) do |delivery, _steps|
      _steps[:pickups] << {
        delivery_id: delivery.id,
        action: 'pickup',
        schedule: pickup_schedule
      }
      _steps[:dropoffs] << {
        delivery_id: delivery.id,
        action: 'dropoff',
        schedule: dropoff_schedule
      }
    end.values.flatten
  end

  def pickup_schedule
    return @pickup_schedule if defined?(@pickup_schedule)

    @pickup_schedule = schedule_param(@allowed_params[:pickup_schedule])
  end

  def dropoff_schedule
    return @dropoff_schedule if defined?(@dropoff_schedule)

    @dropoff_schedule = schedule_param(@allowed_params[:dropoff_schedule])
  end

  def schedule_param(schedule = {})
    now = Time.current
    {
      start: ( schedule[:start].present? ? schedule[:start] : now ),
      end: ( schedule[:end].present? ? schedule[:end] : (now + 1.hour) )
    }
  end
end
