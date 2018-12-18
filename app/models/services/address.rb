module Services
  class Address < Services::UserService
    attributes :id, :street_1, :street_2, :zip_code, :city, :state, :country,
               :contact_name, :contact_cellphone, :contact_email, :telephone,
               :open_hours, :notes, :coordinates, :gps_coordinates,
               :institution_id, :latln

    belongs_to :institution

    def _read_attribute(col)
      send col
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
end
