class OrderSerializer < Simple::OrderSerializer
  has_many :deliveries, serializer: Simple::DeliverySerializer

  def giver
    binding.pry
    ActiveModelSerializers::SerializableResource.new(
      object.giver,
      { serializer: Simple::InstitutionSerializer }
    ).as_json[:institution]
  end

  def receiver
    ActiveModelSerializers::SerializableResource.new(
      object.receiver,
      { serializer: Simple::InstitutionSerializer }
    ).as_json[:institution]
  end
end
