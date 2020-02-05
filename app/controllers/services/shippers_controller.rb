module Services
  class ShippersController < BaseController

    def index
      network = request.headers.fetch('X-Network-Id', '')

      if network.present?
        shippers = Shipper.unscoped.where(network_id: network)
      else
        shippers = Shipper.unscoped.all
      end

      render json: shippers
    end
  end
end