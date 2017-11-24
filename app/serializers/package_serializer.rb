class PackageSerializer < ActiveModel::Serializer
  attributes :id,
    :weigth,
    :volume,
    :cooling,
    :description

  belongs_to :delivery
end
