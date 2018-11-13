RGeo::ActiveRecord::SpatialFactoryStore.instance.tap do |config|
  config.register(RGeo::Geographic.spherical_factory(srid: 4326), geo_type: "point")
end

RGeo::ActiveRecord::GeometryMixin.set_json_generator(:geojson)

# TODO:FIx this, it's mainly caused because the config of RGeo doesn't initialize well on activeresources
class Address::GpsCoordinates
  def factory
    RGeo::Geographic.spherical_factory(srid: 4326)
  end

  def geometry_type
    RGeo::Feature::Point
  end

  def srid
    factory.srid
  end

  def x
    @x ||= self.coordinates.first
  end

  def y
      @x ||= self.coordinates.last
  end

  def z
    @z
  end
end
