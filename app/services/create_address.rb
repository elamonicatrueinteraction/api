class CreateAddress
  prepend Service::Base
  include Service::Support::Address

  def initialize(institution, allowed_params)
    @institution = institution
    @allowed_params = allowed_params
  end

  def call
    create_address
  end

  private

  def create_address
    @address = @institution.addresses.new( address_params(@allowed_params) )

    return @address if @address.save

    errors.add_multiple_errors(@address.errors.messages) && nil
  end

end
