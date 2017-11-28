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
    if order = Order.find_by(id: @allowed_params[:order_id])
      if order.deliveries.blank?
        errors.add(:type, I18n.t("services.create_trip.deliveries.missing_or_invalid", id: @allowed_params[:order_id])) && nil
      end

      @deliveries = order.deliveries.preload(:origin, :destination)
    else
      errors.add(:type, I18n.t("services.create_trip.order.missing_or_invalid", id: @allowed_params[:order_id])) && nil
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
      return errors.add(:exceptopm, e.message ) && nil
    end

    @trip
  end

  def trip_params
    {
      shipper: load_shipper(@allowed_params[:shipper_id]),
      comments: @allowed_params[:comments],
      amount: @deliveries.map(&:amount).sum,
      schedule_at: schedule_datetime,
      pickups: pickups_data,
      dropoffs: dropoffs_data
    }
  end

  def schedule_datetime
    @allowed_params[:schedule_at] ? @allowed_params[:schedule_at] : Time.now
  end

  def pickups_data
    @deliveries.map do |delivery|
      location_data(delivery.id, delivery.origin)
    end
  end

  def dropoffs_data
    @deliveries.map do |delivery|
      location_data(delivery.id, delivery.destination)
    end
  end

  def location_data(id, address)
    {
      place: address.institution.name,
      delivery_id: id,
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

  def contact_data(address)
    {
      name: address.contact_name,
      cellphone: address.contact_cellphone,
      email: address.contact_email
    }
  end

end
