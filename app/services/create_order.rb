class CreateOrder
  prepend Service::Base

  def initialize(allowed_params)
    @allowed_params = allowed_params
  end

  def call
    create_order
  end

  private

  PARAMS_KEYS = %w(
    giver_id
    receiver_id
    expiration
    amount
    bonified_amount
    marketplace_order_id
    delivery_preference
  ).freeze

  def create_order
    @order = Order.new( order_params )

    return if errors.any?

    begin
      Order.transaction do
        @order.save!

        if should_create_delivery?
          CreateDelivery.call(@order, @allowed_params.except(*PARAMS_KEYS), true)
        end
      end
    rescue Service::Error, ActiveRecord::RecordInvalid => e
      Rails.logger.info e
      return errors.add_multiple_errors( exception_errors(e) ) && nil
    end

    @order
  end

  def order_params
    {
      expiration: @allowed_params[:expiration],
      amount: @allowed_params[:amount],
      bonified_amount: @allowed_params[:bonified_amount],
      giver_id: @allowed_params[:giver_id],
      receiver_id: @allowed_params[:receiver_id],
    }.tap do |_hash|
      _hash[:giver] = load_institution('giver', @allowed_params[:giver_id]).as_json if @allowed_params[:giver_id].present?
      _hash[:receiver] = load_institution('receiver', @allowed_params[:receiver_id]).as_json if @allowed_params[:receiver_id].present?
      _hash[:network_id] = _hash[:giver]['network_id'] if _hash[:giver].present?
      _hash[:marketplace_order_id] = @allowed_params[:marketplace_order_id] if @allowed_params[:marketplace_order_id].present?
      _hash[:delivery_preference] = @allowed_params[:delivery_preference] if @allowed_params[:delivery_preference].present?
    end
  end

  def load_institution(action, id)
    if institution = Institution.find_by(id: id)
      institution
    else
      errors.add(:type, I18n.t("services.create_order.#{action}.missing_or_invalid", id: id)) && nil
    end
  end

  def should_create_delivery?
    @allowed_params.key?(:origin_id) && @allowed_params.key?(:destination_id)
  end

end
