class Address < ApplicationRecord
  # Because the Institution is not an ApplicationRecord we need to do this
  # instead of using belongs_to :institution
  def institution
    return nil unless institution_id

    @institution ||= Institution.find_by(id: institution_id)
  end
  attribute :institution

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
