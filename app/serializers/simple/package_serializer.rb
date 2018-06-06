class Simple::PackageSerializer < ActiveModel::Serializer
  attributes :id,
    :quantity,
    :weight,
    :volume,
    :fragile,
    :cooling,
    :description
end
