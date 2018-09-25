module Services
  class OrdersController < BaseController

    def create
      service = CreateOrder.call(full_params)

      if service.success?
        order = service.result

        order_payment = CreatePayment.call(order, order.amount, payment_method)
        delivery = order.deliveries.last
        delivery_payment = CreatePayment.call(delivery, delivery.amount, payment_method)

        order.reload

        render json: order, status: :created # 201
      else
        render json: { errors: service.errors }, status: :unprocessable_entity # 422
      end
    end

    private

    def full_params
      order_params.tap do |_params|
        _params[:origin_id] = get_address_id(_params[:giver_id])
        _params[:destination_id] = get_address_id(_params[:receiver_id])
        _params[:packages] = [{
          quantity: order_items.size,
          weight: order_items.map{ |item| item.dig(:total_weight) }
        }]
        _params[:marketplace_order_id] = marketplace_order_id
        _params[:delivery_preference] = delivery_preference
      end
    end

    def plain_hash_params
      @plain_params ||= params.to_unsafe_hash
    end

    def order_params
      params.require(:order).permit(
        :giver_id,
        :receiver_id,
        :amount,
        :delivery_amount, # For the delivery
        options: [], # For the delivery
      ).to_unsafe_hash
    end

    def marketplace_order_id
      plain_hash_params.dig(:order, :marketplace_order_id)
    end

    def delivery_preference
      plain_hash_params.dig(:order, :delivery_preference)
    end

    def payment_method
      plain_hash_params.dig(:order, :payment_method)
    end

    def order_items
      plain_hash_params.dig(:order, :order_items)
    end

    def get_address_id(institution_id)
      Address.find_by(institution_id: institution_id).try(:id)
    end

  end
end
