class DestroyDelivery
  prepend Service::Base

  def initialize(delivery)
    @delivery = delivery
  end

  def call
    destroy_delivery
  end

  private

  def destroy_delivery
    return unless can_detroy_delivery?

    @delivery.destroy ? @delivery : errors.add_multiple_errors(@delivery.errors.full_messages) && nil
  end

  def can_detroy_delivery?
    if @delivery.trip.present?
      errors.add(:type, I18n.t("services.destroy_delivery.delivery_with_trip")) && nil
      return false
    end
    true
  end

end
