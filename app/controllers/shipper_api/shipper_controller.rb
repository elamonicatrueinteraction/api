module ShipperApi
  class ShipperController < BaseController

    def accepted_terms
      shipper = current_shipper
      shipper.has_accepted_tdu = true
      shipper.save!
      render json: {result: shipper}, status: :ok
    end
  end
end