module Webhooks
  class ShippifyController < ApplicationController
    skip_before_action :authorize_request

    def update_delivery
      if delivery = Delivery.find_by(gateway: 'Shippify', gateway_id: shippify_id)
        Gateway::Shippify::Webhooks::UpdateDelivery.call(delivery, shippify_id)
      end
      render json: nil, status: :ok # 200
    end

    private

    def shippify_id
      @shippify_id ||= allowed_params[:id]
    end

    def allowed_params
      @allowed_params ||= params.permit(
        :id,
        :orderId,
        :route,
        :status,
        :_status,
        :company_id,
        :timestamp,
      )
    end

  end
end
