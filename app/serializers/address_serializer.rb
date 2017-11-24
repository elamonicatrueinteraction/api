class AddressSerializer < ActiveModel::Serializer
  attributes :id,
    :latlng,
    :street_1,
    :street_2,
    :zip_code,
    :city,
    :state,
    :country,
    :telephone,
    :open_hours,
    :notes,
    :created_at,
    :updated_at

  belongs_to :institution
end



