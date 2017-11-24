class CreatePackages
  prepend Service::Base

  def initialize(delivery, packages_params, within_transaction = false)
    @delivery = delivery
    @packages_params = packages_params
    @within_transaction = within_transaction
    @packages = []
  end

  def call
    create_packages
  end

  private

  def create_packages
    begin
      Package.transaction do
        @packages_params.each do |allowed_params|
          @packages << Package.create!( package_params(allowed_params) )
        end
      end

    rescue ActiveRecord::RecordInvalid => e
      errors.add_multiple_errors( e.record.errors.messages )

      @within_transaction ? (raise Service::Error.new(self)) : (return nil)
    end

    @packages
  end

  def package_params(allowed_params)
    {
      delivery: @delivery,
      weigth: allowed_params[:weigth],
      volume: allowed_params[:volume],
      cooling: allowed_params[:cooling],
      description: allowed_params[:description]
    }
  end

end
