class Milestone < ApplicationRecord
  default_scope_by_network
  attribute :data, :jsonb, default: {}

  belongs_to :trip
  has_one :shipper, through: :trip

  validates_presence_of :name, :gps_coordinates

  attribute :latlng
  def latlng
    return unless gps_coordinates

    gps_coordinates.coordinates.reverse.join(",")
  end
end
