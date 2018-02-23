class DestroyPackage
  prepend Service::Base

  def initialize(package)
    @package = package
  end

  def call
    destroy_package
  end

  private

  def destroy_package
    return unless can_detroy_package?

    @package.destroy ? @package : errors.add_multiple_errors(@package.errors.full_messages) && nil
  end

  def can_detroy_package?
    if @package.delivery.trip.present?
      errors.add(:type, I18n.t("services.destroy_package.delivery_with_trip")) && nil
      return false
    end
    true
  end

end
