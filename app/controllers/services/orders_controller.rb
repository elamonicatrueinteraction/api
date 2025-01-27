module Services
  class OrdersController < BaseController
    def index
      render json: Services::OrderQuery.new(params).collection, adapter: :attributes
    end

    def create
      marketplace_order_id = full_params[:marketplace_order_id]
      network_id = full_params[:network_id]
      Rails.logger.info "[CreateOrderService] - Creating order #{marketplace_order_id} in #{network_id} from MKP"
      service = CreateOrder.call(full_params)

      if service.success?
        order = service.result
        make_order_rule = Tenant::ShouldMakeOrderCouponRule.new
        if make_order_rule.should_make?(order)
          order_payment = CreatePayment.call(payable: order, amount: order.amount, payment_type: payment_method)
        else
          Rails.logger.info "[Coupons] - Skipping Coupon generation for ROSARIO - BAR."
        end

        delivery = order.deliveries.last
        if with_delivery_payment
          delivery_payment = CreatePayment.call(payable: delivery, amount: delivery.amount, payment_type: payment_method)
        end
        order.payments.reload
        order.reload
        render json: order, status: :created # 201
      else
        render json: { errors: service.errors }, status: :unprocessable_entity # 422
      end
    end

    def last_order_date
      institution_id = last_order_params[:institution_id]
      network_id = last_order_params[:network_id]
      query = Orders::LastOrderAtQuery.new(network_id: network_id)
      result = query.query(institution_id: institution_id)
      render json: { last_order_dates: result }, status: :ok
    end

    private

    def last_order_params
      params.permit(:network_id, :institution_id)
    end

    def full_params
      order_params.tap do |_params|
        _params[:packages] = [{
          quantity: order_items.size,
          weight: order_items.sum{ |item| item.dig(:total_weight).to_f }
        }]
        _params[:marketplace_order_id] = marketplace_order_id
        _params[:delivery_preference] = delivery_preference
        _params[:network_id] = request.headers['X-Network-Id']
      end
    end

    def plain_hash_params
      @plain_params ||= params.to_unsafe_hash
    end

    def order_params
      params.require(:order).permit(
        :giver_id,
        :receiver_id,
        :origin_id,
        :destination_id,
        :amount,
        :with_delivery,
        :offer_id,
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

    def with_delivery_payment
      plain_hash_params.dig(:order, :with_delivery_payment)
    end
  end
end