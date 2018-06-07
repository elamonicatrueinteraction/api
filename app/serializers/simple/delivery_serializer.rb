class Simple::DeliverySerializer < ActiveModel::Serializer
  attributes :id,
    :amount,
    :bonified_amount,
    :status,
    :origin_latlng,
    :destination_latlng,
    :options,
    :payments

  def payments
    ActiveModelSerializers::SerializableResource.new(
      object.payments,
      { each_serializer: PaymentSerializer }
    ).as_json[:payments]
  end
end
