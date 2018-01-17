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
      quantity: allowed_params[:quantity],
      weight: allowed_params[:weight],
      volume: allowed_params[:volume],
      description: allowed_params[:description]
    }.tap do |_hash|
      _hash[:cooling] = allowed_params[:cooling] unless allowed_params[:cooling].nil?
      _hash[:fragile] = allowed_params[:fragile] unless allowed_params[:fragile].nil?
    end
  end

end
