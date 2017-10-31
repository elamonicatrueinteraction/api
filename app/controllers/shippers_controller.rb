class ShippersController < ApplicationController
  def show
    shippers = Shipper.all.as_json
    render json: { data: shippers }, status: :ok
  end

  def create
    shipper = Shipper.create!(shipper_params)
    if !shipper.errors.empty?
      render json: {error: shipper.errors.full_messages}, status: 422
    else
      render json: { data: shipper }, status: :ok
    end
  end

  def update
    shipper = Shipper.find(params[:id])
    shipper.update(shipper_params)
    if !shipper.errors.empty?
      render json: {error: shipper.errors.full_messages}, status: 422
    else
      render json: { data: shipper }, status: :ok
    end
  end

  private

  def shipper_params
    params.permit(:first_name, :last_name, :email)
  end
end
