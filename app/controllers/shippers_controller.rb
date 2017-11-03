class ShippersController < ApplicationController
  def index
    shippers = Shipper.all
    render json: { shippers: shippers }, status: :ok # 200
  end

  def create
    shipper = Shipper.create(shipper_params)
    # TODO: Create a validator service
    if shipper.valid?
      render json: { shipper: shipper }, status: :created # 201
    else
      render json: { error: shipper.errors.full_messages }, status: :unprocessable_entity # 422
    end
  end

  def update
    if shipper = Shipper.find_by(id: params[:id])
      shipper.update(shipper_params)
      # TODO: Create a validator service
      if shipper.valid?
        render json: { shipper: shipper }, status: :ok # 200
      else
        render json: { error: shipper.errors.full_messages }, status: :unprocessable_entity # 422
      end
    else
      render json: { error: "Not found" }, status: :not_found # 404
    end
  end

  private

  def shipper_params
    params.permit(
      :first_name,
      :last_name,
      :gender,
      :birth_date,
      :email,
      :phone_num,
      :photo,
      :active,
      :verified,
      :verified_at,
      :national_ids,
      :bank_account,
      :vehicle,
      :minimum_requirements,
      :requirements
    )
  end
end


