class DeliverySerializer < Simple::DeliverySerializer
  attributes :packages,
    :pickup,
    :dropoff,
    :created_at,
    :updated_at

  belongs_to :origin, class_name: 'Address'
  belongs_to :destination, class_name: 'Address'

  belongs_to :order, serializer: Simple::OrderSerializer

  def packages
    ActiveModelSerializers::SerializableResource.new(
      object.packages,
      { each_serializer: Simple::PackageSerializer }
    ).as_json[:packages]
  end
end



