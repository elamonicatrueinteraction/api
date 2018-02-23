class ShippersController < ApplicationController

  def index
    shippers = Shipper.preload(:verifications, :bank_accounts, vehicles: :verifications).all
    render json: shippers, status: :ok # 200
  end

  def create
    shipper = Shipper.create(shipper_params)
    # TODO: Create a validator service
    if shipper.valid?
      render json: shipper, status: :created # 201
    else
      render json: { errors: shipper.errors.full_messages }, status: :unprocessable_entity # 422
    end
  end

  def show
    shipper = Shipper.find_by(id: params[:id])
    render json: shipper, status: :ok # 200
  end

  def update
    if shipper = Shipper.find_by(id: params[:id])
      shipper.update(shipper_params)
      # TODO: Create a validator service
      if shipper.valid?
        Gateway::Shippify::ShipperUpdateWorker.perform_async(shipper.id)

        render json: shipper, status: :ok # 200
      else
        render json: { errors: shipper.errors.full_messages }, status: :unprocessable_entity # 422
      end
    else
      render json: { errors: [ I18n.t('errors.not_found.shipper', id: params[:id]) ] }, status: :not_found # 404
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
      :cuit,
      :cuil,
      :gateway,
      :gateway_id,
      requirements: requirements_params,
      minimum_requirements: minimum_requirements_params
    )
  end

  def requirements_params
    # TODO: Chequear [ :verified, :uri, :expiration_date, data: {} ] para que sea dinamico
    Shipper::REQUIREMENTS.each_with_object({}) do |requirement, _hash|
      _hash[requirement] = [ :verified, :uri, :expiration_date, data: {} ]
    end
  end

  def minimum_requirements_params
    # TODO: Chequear [ :verified, :uri, :expiration_date, data: {} ] para que sea dinamico
    Shipper::MINIMUM_REQUIREMENTS.each_with_object({}) do |requirement, _hash|
      _hash[requirement] = [ :verified, :uri, :expiration_date, data: {} ]
    end
  end
end
