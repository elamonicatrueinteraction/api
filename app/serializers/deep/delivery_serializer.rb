class Deep::DeliverySerializer < Simple::DeliverySerializer
  attributes :packages

  has_many :payments

  def packages
    ActiveModelSerializers::SerializableResource.new(
      object.packages,
      { each_serializer: Simple::PackageSerializer }
    ).as_json[:packages]
  end
end
