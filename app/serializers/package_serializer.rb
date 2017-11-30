class PackageSerializer < ActiveModel::Serializer
  attributes :id,
    :quantity,
    :weigth,
    :volume,
    :fragile,
    :cooling,
    :description

  belongs_to :delivery, serializer: Simple::DeliverySerializer
end
