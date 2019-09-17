# == Schema Information
#
# Table name: vehicles
#
#  id         :uuid             not null, primary key
#  shipper_id :uuid
#  model      :string           not null
#  brand      :string
#  year       :integer
#  extras     :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  max_weight :integer
#  network_id :string
#

class VehicleSerializer < Simple::VehicleSerializer
  attributes :features

  belongs_to :shipper, serializer: Simple::ShipperSerializer
end
