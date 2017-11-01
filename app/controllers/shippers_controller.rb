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
    shipper = Shipper.find_by(params[:id])
    shipper.update(shipper_params)
    # TODO: Create a validator service
    if shipper.valid?
      render json: { data: shipper }, status: :ok
    else
      render json: {error: shipper.errors.full_messages}, status: 422
    end
  end

  private

  def shipper_params
    params.permit(:first_name, :last_name, :email, :gateway_id)
  end
end
