class PaymentSerializer < ActiveModel::Serializer
  attributes :id,
    :status,
    :amount,
    :collected_amount,
    :gateway_info,

  def gateway_info
    {
      id: object.gateway_id,
      name: object.gateway,
      payment_method_id: paymentMethod,
      coupon_url: externalResourceUrl
    }
  end

  def paymentMethod
    return if object.status == 'failed'

    object[:gateway_data][:payment_method_id]
  end

  def externalResourceUrl
    return if object.status == 'failed'
    object[:gateway_data][:transaction_details][:external_resource_url]
  end

end

