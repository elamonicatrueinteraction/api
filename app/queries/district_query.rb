class DistrictQuery
  include Querifier::Queries::Default

  where_attributes :id, :name
  order_attributes :id, :name
end
