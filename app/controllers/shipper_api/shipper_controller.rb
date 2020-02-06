module ShipperApi
  class ShipperController < BaseController

    def accepted_terms
      shipper = current_shipper
      shipper.has_accepted_tdu = true
      shipper.save!
      render json: {result: shipper}, status: :ok
    end

    def logout
      shipper = current_shipper
      devices_hash = (shipper.devices || {}).symbolize_keys

      type = permitted_params[:type].to_sym
      token = permitted_params[:token]

      devices_hash[type] = devices_hash[type] || {}
      devices_hash[type].delete(token)

      shipper.devices = devices_hash
      shipper.save!

      render json: { result: "Logout Success" }, status: :ok # 200
    end

    def permitted_params
      params.require(:device).permit(:type, :token)
    end
  end
end