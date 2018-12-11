class Address < UserApiResource
  cached_resource ttl: 1.minute.to_i
  # Because the Institution is not an ApplicationRecord we need to do this
  # instead of using belongs_to :institution

  def _read_attribute(col)
    send col
  end

  def institution
    return nil unless institution_id

    @institution ||= Institution.find_by(id: institution_id)
  end

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

  def gps_coordinates
    GpsCoordinates.new(coordinates.attributes)
  end

  # TODO: Fix this, it's mainly caused because the config of RGeo
  # doesn't initialize well on activeresources
  class GpsCoordinates < UserApiResource
    def factory
      RGeo::Geographic.spherical_factory(srid: 4326)
    end

    def geometry_type
      RGeo::Feature::Point
    end

    delegate :srid, to: :factory

    def x
      @x ||= coordinates.first
    end

    def y
      @y ||= coordinates.last
    end

    attr_reader :z
  end
end
