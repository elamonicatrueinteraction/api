class InstitutionSerializer < Simple::InstitutionSerializer
  attributes :addresses
  has_many :users

  def addresses
    ActiveModelSerializers::SerializableResource.new(
      object.addresses,
      { each_serializer: Simple::AddressSerializer }
    ).as_json[:packages]
  end
end
