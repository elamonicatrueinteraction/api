class UpdateShipper
  prepend Service::Base

  def initialize(shipper, allowed_params)
    @shipper = shipper
    @allowed_params = allowed_params
  end

  def call
    update_shipper
  end

  private

  def update_shipper
    @shipper.update(@allowed_params)

    return @shipper if @shipper.save

    errors.add_multiple_errors(@shipper.errors.messages) && nil
  end

end
