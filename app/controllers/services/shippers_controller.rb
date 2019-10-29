module Services
  class ShippersController < BaseController

    def index
      network = request.headers.fetch('X-Network-Id', '')
      shippers = Shipper.all
      shippers = shippers.where(network_id: network) if network != ''
      render json: shippers
    end
  end
end