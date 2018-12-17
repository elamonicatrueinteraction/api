module V2
  class PaymentSerializer < ActiveModel::Serializer
    attributes :id, :created_at, :payable_id, :payable_type, :status, :amount,
               :collected_amount, :comment, :gateway_id, :gateway_code,
               :gateway_coupon_url, :gateway_name, :gateway_payment_name,
               :paid_at

    def gateway_id
      object.gateway_data['id']
    end

    def gateway_code
      object.gateway_data['id']
    end

    def gateway_coupon_url
      return if object.status == 'failed'

      object.gateway_data.dig(:transaction_details, :external_resource_url)
    end

    def gateway_name
      object.gateway
    end

    def gateway_payment_name
      object.gateway_data['payment_method_id']
    end
  end
end
