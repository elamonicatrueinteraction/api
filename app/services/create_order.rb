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
      return errors.add_multiple_errors( exception_errors(e, @order) ) && nil
    end

    @order
  end

  def exception_errors(exception, order)
    exception.is_a?(Service::Error) ? exception.service.errors : order.errors.messages
  end

  def order_params
    {
      giver: load_institution('giver', @allowed_params[:giver_id]),
      receiver: load_institution('receiver', @allowed_params[:receiver_id]),
      expiration: @allowed_params[:expiration],
      amount: @allowed_params[:amount],
      bonified_amount: @allowed_params[:bonified_amount]
    }
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
