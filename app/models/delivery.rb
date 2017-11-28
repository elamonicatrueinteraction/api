class Delivery < ApplicationRecord
  attribute :amount, :float
  attribute :bonified_amount, :float

  belongs_to :order
  belongs_to :trip, optional: true
  has_many :packages, dependent: :destroy

  belongs_to :origin, class_name: 'Address'
  belongs_to :destination, class_name: 'Address'

  attribute :origin_latlng
  def origin_latlng
    return unless origin_gps_coordinates

    origin_gps_coordinates.coordinates.reverse.join(", ")
  end
  attribute :destination_latlng
  def destination_latlng
    return unless destination_gps_coordinates

    destination_gps_coordinates.coordinates.reverse.join(", ")
  end
end
