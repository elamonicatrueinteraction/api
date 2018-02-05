class TripSerializer < ActiveModel::Serializer
  attributes :id,
    :status,
    :comments,
    :delivery_amount,
    :package_amount,
    :shipper_name,
    :shipper_avatar_url,
    :steps,
    :created_at,
    :updated_at

  belongs_to :shipper, serializer: Simple::ShipperSerializer
  has_many :deliveries, serializer: Simple::DeliverySerializer
  has_many :packages

  def delivery_amount
    object.amount.to_f
  end

  def package_amount
    object.orders.flat_map(&:amount).compact.sum
  end

  def shipper_name
    object.shipper.full_name if object.shipper
  end

  def shipper_avatar_url
    ''
  end
end
