class Address < ApplicationRecord
  belongs_to :institution, optional: true

  attribute :latlng
  def latlng
    return unless gps_coordinates

    gps_coordinates.coordinates.reverse.join(", ")
  end
end
