class UpdateDelivery
  prepend Service::Base
  include Service::Support::Delivery

  def initialize(delivery, allowed_params)
    @delivery = delivery
    @allowed_params = allowed_params
  end

  def call
    update_delivery
  end

  private

  def update_delivery
    @delivery.assign_attributes( delivery_params )

    return if errors.any?

    return @delivery if @delivery.save

    errors.add_multiple_errors(@delivery.errors.messages) && nil
  end

  def delivery_params
    @allowed_params.tap do |_hash|
      if _hash[:origin_id].present? && (address = load_address('origin', _hash[:origin_id]))
        _hash[:origin] = address
        _hash[:origin_gps_coordinates] = address.gps_coordinates
      end

      if _hash[:destination_id].present? && (address = load_address('destination', _hash[:destination_id]))
        _hash[:destination] = address
        _hash[:destination_gps_coordinates] = address.gps_coordinates
      end
    end
  end

end
