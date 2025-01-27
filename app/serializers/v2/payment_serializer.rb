module V2
  class PaymentSerializer < ActiveModel::Serializer
    attributes :id, :created_at, :payable_id, :payable_type, :status, :amount,
               :collected_amount, :comment, :gateway_id, :gateway_code,
               :gateway_coupon_url, :gateway_name, :gateway_payment_name,
               :paid_at, :activity

    def gateway_id
      return object.gateway_id if object.gateway_data['id'].nil?

      object.gateway_data['id']
    end

    def gateway_code
      return object.gateway_id if object.gateway_data['id'].nil?

      object.gateway_data['id']
    end

    def gateway_coupon_url
      return if object.status == 'failed' || object.status != "201"
      if object.gateway_data.dig(:transaction_details, :external_resource_url).nil?
        return object.gateway_data["response"]["transaction_details"]["external_resource_url"]
      end

      object.gateway_data.dig(:transaction_details, :external_resource_url)
    end

    def payable_type
      if (object.payable_type && object.payable_id)
        klass =  eval object.payable_type
        payable = klass.unscoped.find object.payable_id
        payable&.type
      end
    end

    def activity
      if (object.payable_type && object.payable_id)
        klass =  eval object.payable_type
        payable = klass.unscoped.find object.payable_id

        payable&.type
      end
    end

    def gateway_name
      object.gateway
    end

    def gateway_payment_name
      return "-" if object.gateway_data == {}
      status = object.gateway_data["status"].to_s

      return "-" if status == "400" || status == ""
      return object.gateway_data["response"]["payment_method_id"] if object.gateway_data['payment_method_id'].nil?
      object.gateway_data['payment_method_id']
    end
  end
end
