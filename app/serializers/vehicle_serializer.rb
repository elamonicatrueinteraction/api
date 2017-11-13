class VehicleSerializer < Simple::VehicleSerializer
  attributes :features

  has_many :verifications, serializer: Simple::VerificationSerializer
  belongs_to :shipper, serializer: Simple::ShipperSerializer
end
