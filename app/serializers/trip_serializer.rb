class TripSerializer < ActiveModel::Serializer
  attributes :id,
    :status,
    :comments,
    :amount,
    :steps,
    :created_at,
    :updated_at

  belongs_to :shipper, serializer: Simple::ShipperSerializer
  has_many :orders, serializer: Deep::OrderSerializer
end
