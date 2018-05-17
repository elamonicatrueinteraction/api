class PackageSerializer < Simple::PackageSerializer
  belongs_to :delivery, serializer: Simple::DeliverySerializer
end
