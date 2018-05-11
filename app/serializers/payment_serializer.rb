class PaymentSerializer < ActiveModel::Serializer
  attributes :id,
    :payable,
    :status,
    :amount,
    :collected_amount,
    :gateway_info,

  def gateway_info
    {
      id: object.gateway_id,
      name: object.gateway,
      payment_method_id: payment_method_id,
      coupon_url: coupon_url
    }
  end

  def payable
    {
      id: object.payable_id,
      type: object.payable_type.downcase
    }
  end

  def payment_method_id
    return if object.status == 'failed'

    object.gateway_data[:payment_method_id]
  end

  def coupon_url
    return if object.status == 'failed'

    object.gateway_data.dig(:transaction_details, :external_resource_url)
  end

end

