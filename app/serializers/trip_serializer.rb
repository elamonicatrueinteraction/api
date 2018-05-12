class TripSerializer < ActiveModel::Serializer
  attributes :id,
    :status,
    :comments,
    :shipper_name,
    :shipper_avatar_url,
    :steps,
    :created_at,
    :updated_at

  belongs_to :shipper, serializer: Simple::ShipperSerializer
  has_many :orders, serializer: Simple::OrderSerializer
  has_many :deliveries, serializer: Simple::DeliverySerializer
  has_many :packages

  def shipper_name
    object.shipper.full_name if object.shipper
  end

  def shipper_avatar_url
    ''
  end
end
