class CreateTrip
  prepend Service::Base
  include Service::Support::Trip

  def initialize(allowed_params)
    @allowed_params = allowed_params
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
        errors.add(:type, I18n.t("services.create_trip.deliveries.missing_or_invalid", id: @allowed_params[:orders_ids].join(', '))) && nil
      end

      @deliveries = orders.flat_map do |order|
        order.deliveries.preload(:origin, :destination)
      end
    else
      errors.add(:type, I18n.t("services.create_trip.order.missing_or_invalid", id: @allowed_params[:orders_ids].join(', '))) && nil
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

    @trip
  end

  def trip_params
    {
      comments: @allowed_params[:comments],
      amount: @deliveries.map(&:amount).sum,
      pickups: pickups_data,
      dropoffs: dropoffs_data
    }.tap do |_hash|
      _hash[:status] = @allowed_params[:status] if @allowed_params[:status]
      _hash[:shipper] = load_shipper(@allowed_params[:shipper_id]) if @allowed_params[:shipper_id]

      _hash[:gateway] = @allowed_params[:gateway] if @allowed_params[:gateway]
      _hash[:gateway_id] = @allowed_params[:gateway_id] if @allowed_params[:gateway_id]
      _hash[:gateway_data] = @allowed_params[:gateway_data] if @allowed_params[:gateway_data]
    end
  end

  def schedule_datetime
    @allowed_params[:schedule_at] ? @allowed_params[:schedule_at] : Time.now
  end

  def pickups_data
    @deliveries.map do |delivery|
      location_data(delivery.id, delivery.origin, @allowed_params[:pickup_schedule])
    end
  end

  def dropoffs_data
    @deliveries.map do |delivery|
      location_data(delivery.id, delivery.destination, @allowed_params[:dropoff_schedule])
    end
  end

  def location_data(id, address, schedule = {})
    {
      place: place_name(address),
      delivery_id: id,
      schedule: schedule,
      address: {
        id: address.id,
        telephone: address.telephone,
        street_1: address.street_1,
        street_2: address.street_2,
        zip_code: address.zip_code,
        city: address.city,
        state: address.state,
        country: address.country
      },
      latlng: address.latlng,
      open_hours: address.open_hours,
      notes: address.notes,
      contact: contact_data(address)
    }
  end

  def place_name(address)
    address.institution ? address.institution.name : address.lookup
  end

  def contact_data(address)
    {
      name: address.contact_name,
      cellphone: address.contact_cellphone,
      email: address.contact_email
    }
  end

end
