class DeliveriesController < ApplicationController
  include CurrentAndEnsureDependencyLoader

  def index
    ensure_order; return if performed?

    deliveries = current_order.deliveries
    render json: deliveries, status: :ok # 200
  end

  def show
    ensure_order; return if performed?

    if delivery = current_order.deliveries.find_by(id: params[:id])
      render json: delivery, status: :ok # 200
    else
      render json: { error: I18n.t('errors.not_found.delivery', delivery_id: params[:id], order_id: params[:order_id]) }, status: :not_found # 404
    end
  end

  def create
    ensure_order; return if performed?

    service = CreateDelivery.call(current_order, create_delivery_params)

    if service.success?
      render json: service.result, status: :created # 201
    else
      render json: { error: service.errors }, status: :unprocessable_entity # 422
    end
  end

  def update
    ensure_order; return if performed?

    if delivery = current_order.deliveries.find_by(id: params[:id])
      service = UpdateDelivery.call(delivery, update_delivery_params)

      if service.success?
        render json: service.result, status: :created # 201
      else
        render json: { error: service.errors }, status: :unprocessable_entity # 422
      end
    else
      render json: { error: I18n.t('errors.not_found.delivery', delivery_id: params[:id], order_id: params[:order_id]) }, status: :not_found # 404
    end
  end

  def destroy
    ensure_order; return if performed?

    if delivery = current_order.deliveries.find_by(id: params[:id])
      service = DestroyDelivery.call(delivery)

      if service.success?
        render json: { delivery: delivery.id }, status: :ok # 200
      else
        render json: { error: service.errors }, status: :unprocessable_entity # 422
      end
    else
      render json: { error: I18n.t('errors.not_found.delivery', delivery_id: params[:id], order_id: params[:order_id]) }, status: :not_found # 404
    end
  end

  private

  def create_delivery_params
    params.permit(
      :origin_id,
      :destination_id,
      :amount,
      :bonified_amount,
      packages: [
        :weigth,
        :volume,
        :fragile,
        :cooling,
        :description
      ]
    )
  end

  def update_delivery_params
    params.permit(
      :origin_id,
      :destination_id,
      :amount,
      :bonified_amount
    )
  end

end
