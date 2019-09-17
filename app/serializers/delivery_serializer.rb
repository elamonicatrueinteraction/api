# == Schema Information
#
# Table name: deliveries
#
#  id                          :bigint(8)        not null, primary key
#  order_id                    :uuid
#  trip_id                     :uuid
#  amount                      :decimal(12, 4)   default(0.0)
#  bonified_amount             :decimal(12, 4)   default(0.0)
#  origin_id                   :uuid
#  origin_gps_coordinates      :geography({:srid point, 4326
#  destination_id              :uuid
#  destination_gps_coordinates :geography({:srid point, 4326
#  status                      :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  gateway                     :string
#  gateway_id                  :string
#  gateway_data                :jsonb
#  pickup                      :jsonb
#  dropoff                     :jsonb
#  extras                      :jsonb
#

class DeliverySerializer < Simple::DeliverySerializer
  attributes :packages,
    :pickup,
    :dropoff,
    :created_at,
    :updated_at

  belongs_to :origin, class_name: 'Address'
  belongs_to :destination, class_name: 'Address'

  belongs_to :order, serializer: Simple::OrderSerializer

  def packages
    ActiveModelSerializers::SerializableResource.new(
      object.packages,
      { each_serializer: Simple::PackageSerializer }
    ).as_json[:packages]
  end
end



