class Simple::VehicleSerializer < ActiveModel::Serializer
  attributes :id, :model, :brand, :year
end

