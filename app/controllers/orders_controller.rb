class OrdersController < ApplicationController
  include CurrentAndEnsureDependencyLoader

  def index
    optional_institution; return if performed?

    finder =
      Finder::Orders.call(institution_id: params.fetch(:institution_id, current_institution&.id),
                          filter_params: filter_params)
    results = finder.result
    Rails.logger.debug "Found #{results.length} orders"
    if results.length > 0
      Rails.logger.debug "Example order  #{results[0].to_yaml}"
      Rails.logger.debug "First order giver #{results[0].giver.to_yaml}"
      Rails.logger.debug "First order giver #{results[0].receiver.to_yaml}"
    end
    render json: list_results(finder.result), each_serializer: OrderSerializer, status: :ok # 200
  end

  def create
    service = CreateOrder.call(order_params)

    if service.success?
      render json: service.result, status: :created # 201
    else
      render json: { errors: service.errors }, status: :unprocessable_entity # 422
    end
  end

  def show
    if order = Order.find_by(id: params[:id])
      render json: order, status: :ok # 200
    else
      render json: { errors: I18n.t('errors.not_found.order', id: params[:id]) }, status: :not_found # 404
    end
  end

  def destroy
    if order = Order.find_by(id: params[:id])
      service = DestroyOrder.call(order)

      if service.success?
        render json: { order: order.id }, status: :ok # 200
      else
        render json: { errors: service.errors }, status: :unprocessable_entity # 422
      end
    else
      render json: { errors: I18n.t('errors.not_found.order', id: params[:id]) }, status: :not_found # 404
    end
  end

  private

  def order_params
    params.permit(
      :giver_id,
      :receiver_id,
      :expiration,
      :amount,
      :bonified_amount,
      :origin_id, # For the delivery
      :destination_id, # For the delivery
      :delivery_amount, # For the delivery
      :delivery_bonified_amount, # For the delivery
      delivery_preference: [:day, :time],
      options: [], # For the delivery
      packages: [
        :quantity,
        :weight,
        :volume,
        :fragile,
        :cooling,
        :description
      ]
    )
  end

  def filter_params
    params.permit(
      :created_since,
      :created_until
    )
  end

end
