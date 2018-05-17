class Deep::OrderSerializer < Simple::OrderSerializer
  attributes :deliveries

  def deliveries
    ActiveModelSerializers::SerializableResource.new(
      object.deliveries,
      { each_serializer: Deep::DeliverySerializer }
    ).as_json[:deliveries]
  end
end
