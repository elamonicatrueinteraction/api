class DestroyOrder
  prepend Service::Base

  def initialize(order)
    @order = order
  end

  def call
    destroy_order
  end

  private

  def destroy_order
    return unless can_detroy_order?

    @order.destroy ? @order : errors.add_multiple_errors(@order.errors.full_messages) && nil
  end

  def can_detroy_order?
    if @order.deliveries.any?{ |delivery| delivery.trip.present? }
      errors.add(:type, I18n.t("services.destroy_order.delivery_with_trip")) && nil
      return false
    end
    true
  end

end
