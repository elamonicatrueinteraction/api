class Simple::DeliverySerializer < ActiveModel::Serializer
  attributes :id,
    :amount,
    :bonified_amount,
    :status,
    :origin_latlng,
    :destination_latlng,
    :options,
    :payments,
    :packages

  def payments
    ActiveModelSerializers::SerializableResource.new(
      object.payments,
      { each_serializer: PaymentSerializer }
    ).as_json[:payments]
  end

  def packages
    ActiveModelSerializers::SerializableResource.new(
      object.packages,
      { each_serializer: Simple::PackageSerializer }
    ).as_json[:packages]
  end
end
