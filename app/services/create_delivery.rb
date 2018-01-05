class CreateDelivery
  prepend Service::Base
  include Service::Support::Delivery

  def initialize(order, allowed_params, within_transaction = false)
    @order = order
    @allowed_params = normalize_params(allowed_params)
    @within_transaction = within_transaction
  end

  def call
    create_delivery
  end

  private

  def normalize_params(allowed_params)
    return allowed_params if allowed_params.key?(:amount) && allowed_params.key?(:bonified_amount)

    allowed_params.tap do |_hash|
      _hash[:amount] ||= _hash.delete(:delivery_amount) if _hash.key?(:delivery_amount)
      _hash[:bonified_amount] ||= _hash.delete(:delivery_bonified_amount) if _hash.key?(:delivery_bonified_amount)
    end
  end

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
      amount: @allowed_params[:amount],
      bonified_amount: @allowed_params[:bonified_amount]
    }.tap do |_hash|
      _hash[:status] = @allowed_params[:status] if @allowed_params[:status]
      _hash[:origin_gps_coordinates] = _hash[:origin].gps_coordinates if _hash[:origin]
      _hash[:destination_gps_coordinates] =  _hash[:destination].gps_coordinates if _hash[:destination]

      _hash[:gateway] = @allowed_params[:gateway] if @allowed_params[:gateway]
      _hash[:gateway_id] = @allowed_params[:gateway_id] if @allowed_params[:gateway_id]
      _hash[:gateway_data] = @allowed_params[:gateway_data] if @allowed_params[:gateway_data]
    end
  end

  def should_create_packages?
    @allowed_params[:packages].present?
  end

end
