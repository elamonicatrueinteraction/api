class UpdateAddress
  prepend Service::Base
  include Service::Support::Address

  def initialize(address, allowed_params)
    @address = address
    @allowed_params = allowed_params
  end

  def call
    update_address
  end

  private

  def update_address
    @address.assign_attributes( address_params(@allowed_params, true) )

    return if errors.any?

    return @address if @address.save

    errors.add_multiple_errors(@address.errors.messages) && nil
  end

end
