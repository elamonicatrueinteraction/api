class CreateTrip
  prepend Service::Base
  include Service::Support::Trip

  def initialize(allowed_params)
    @allowed_params = allowed_params
    @shipper = load_shipper(@allowed_params[:shipper_id]) if @allowed_params[:shipper_id]
  end

  def call
    load_deliveries

    return if errors.any?

    ensure_non_asigned_deliveries

    return if errors.any?

    create_trip
  end

  private

  def load_deliveries
    if orders = Order.where(id: @allowed_params[:orders_ids]).includes(:deliveries)
      if orders.blank? || orders.any?{ |order| order.deliveries.blank? }
        return errors.add(:type, I18n.t("services.create_trip.deliveries.missing_or_invalid", id: @allowed_params[:orders_ids].join(', ')))
      end

      @deliveries = orders.flat_map(&:deliveries)
    else
      errors.add(:type, I18n.t("services.create_trip.order.missing_or_invalid", id: @allowed_params[:orders_ids].join(', ')))
    end
  end

  def ensure_non_asigned_deliveries
    if @deliveries.any?{ |delivery| delivery.trip.present? }
      errors.add(:assign, I18n.t("services.create_trip.deliveries.already_assigned"))
    end
  end

  def create_trip
    @trip = Trip.new( trip_params )

    return if errors.any?

    begin
      Trip.transaction do
        @trip.save!

        @deliveries.each do |delivery|
          delivery.update!(trip: @trip, status: 'assigned')
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
      steps: steps_data(
        @deliveries,
        @allowed_params[:pickup_schedule],
        @allowed_params[:dropoff_schedule]
      )
    }
  end
end
