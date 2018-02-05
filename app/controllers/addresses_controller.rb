class AddressesController < ApplicationController
  include CurrentAndEnsureDependencyLoader

  def index
    ensure_institution; return if performed?

    addresses = current_institution.addresses
    render json: addresses, status: :ok # 200
  end

  def create
    ensure_institution; return if performed?

    service = CreateAddress.call(current_institution, address_params)

    if service.success?
      address = service.result

      Gateway::Shippify::PlaceWorker.perform_async(address.id, 'create')

      render json: address, status: :created # 201
    else
      render json: { errors: service.errors }, status: :unprocessable_entity # 422
    end
  end

  def update
    ensure_institution; return if performed?

    if address = current_institution.addresses.find_by(id: params[:id])
      service = UpdateAddress.call(address, address_params)

      if service.success?
        Gateway::Shippify::PlaceWorker.perform_async(address.id, 'update')

        render json: service.result, status: :ok # 200
      else
        render json: { errors: service.errors }, status: :unprocessable_entity # 422
      end
    else
      render json: { errors: I18n.t('errors.not_found.address', address_id: params[:id], institution_id: params[:institution_id]) }, status: :not_found # 404
    end
  end

  def destroy
    ensure_institution; return if performed?

    if address = current_institution.addresses.find_by(id: params[:id])
      if address.destroy
        render json: { address: address.id }, status: :ok # 200
      else
        render json: { errors: address.errors.full_messages }, status: :unprocessable_entity # 422
      end
    else
      render json: { errors: I18n.t('errors.not_found.address', address_id: params[:id], institution_id: params[:institution_id]) }, status: :not_found # 404
    end
  end

  private

  def address_params
    params.permit(
      :latlng,
      :street_1,
      :street_2,
      :zip_code,
      :city,
      :state,
      :country,
      :contact_name,
      :contact_cellphone,
      :contact_email,
      :telephone,
      :open_hours,
      :notes
    )
  end

end
