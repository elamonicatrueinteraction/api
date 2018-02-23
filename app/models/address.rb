class Address < ApplicationRecord
  belongs_to :institution, optional: true

  attribute :latlng
  def latlng
    return unless gps_coordinates

    gps_coordinates.coordinates.reverse.join(",")
  end

  def lookup_address
    @lookup_address ||= [
      street_1,
      [zip_code, city].compact.join(' '),
      state,
      country
    ].compact.join(', ')
  end
end
