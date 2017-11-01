class ShippersController < ApplicationController
  def index
    shippers = Shipper.all
    render json: { data: shippers }, status: :ok
  end

  def create
    shipper = Shipper.create(shipper_params)
    # TODO: Create a validator service
    if shipper.valid?
      render json: { data: shipper }, status: :ok
    else
      render json: {error: shipper.errors.full_messages}, status: 422
    end
  end

  def update
    if shipper = Shipper.find_by(id: params[:id])
      shipper.update(shipper_params)
      # TODO: Create a validator service
      if shipper.valid?
        render json: { data: shipper }, status: :ok
      else
        render json: {error: shipper.errors.full_messages}, status: 422
      end
    else
      render json: {error: "Not found"}, status: 404
    end
  end

  private

  def shipper_params
    params.permit(:first_name, :last_name, :email, :gateway_id)
  end
end
