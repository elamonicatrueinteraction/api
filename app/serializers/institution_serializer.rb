class InstitutionSerializer < Simple::InstitutionSerializer
  attributes :addresses
  has_many :users

  def addresses
    ActiveModelSerializers::SerializableResource.new(
      object.addresses,
      { each_serializer: AddressSerializer }
    ).as_json[:packages]
  end
end
