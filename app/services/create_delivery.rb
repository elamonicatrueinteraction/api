class CreateDelivery
  prepend Service::Base

  def initialize(order, allowed_params, within_transaction = false)
    @order = order
    @allowed_params = allowed_params
    @within_transaction = within_transaction
  end

  def call
    create_delivery
  end

  private

  def create_delivery
    @delivery = Delivery.new( delivery_params )

    if errors.any?
      @within_transaction ? (raise Service::Error.new(self)) : (return nil)
    end

    begin
      Delivery.transaction do
        @delivery.save!

        if should_create_packages?
          CreatePackages.call(@delivery, @allowed_params[:packages], true)
        end
      end
    rescue Service::Error, ActiveRecord::RecordInvalid => e
      errors.add_multiple_errors( exception_errors(e, @delivery) )

      @within_transaction ? (raise Service::Error.new(self)) : (return nil)
    end

    @delivery
  end

  def exception_errors(exception, delivery)
    exception.is_a?(Service::Error) ? exception.service.errors : delivery.errors.messages
  end

  def delivery_params
    {
      order: @order,
      origin: load_address('origin', @allowed_params[:origin_id]),
      destination: load_address('destination', @allowed_params[:destination_id]),
      amount: @allowed_params[:delivery_amount],
      bonified_amount: @allowed_params[:delivery_bonified_amount]
    }.tap do |_hash|
      _hash[:origin_gps_coordinates] = _hash[:origin].gps_coordinates
      _hash[:destination_gps_coordinates] =  _hash[:destination].gps_coordinates
    end
  end

  def load_address(action, id)
    if address = Address.find_by(id: id)
      address
    else
      id = id.empty? ? '(empty)' : id
      errors.add(:type, I18n.t("services.create_delivery.#{action}.missing_or_invalid", id: id)) && nil
    end
  end

  def should_create_packages?
    @allowed_params[:packages].present?
  end

end
