class VehicleSerializer < Simple::VehicleSerializer
  attributes :features

  belongs_to :shipper, serializer: Simple::ShipperSerializer
end
