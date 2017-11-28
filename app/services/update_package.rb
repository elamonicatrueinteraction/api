class UpdatePackage
  prepend Service::Base

  def initialize(package, allowed_params)
    @package = package
    @allowed_params = allowed_params
  end

  def call
    update_package
  end

  private

  def update_package
    @package.assign_attributes( @allowed_params )

    return @package if @package.save

    errors.add_multiple_errors(@package.errors.messages) && nil
  end

end
