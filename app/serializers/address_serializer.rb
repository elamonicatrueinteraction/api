class AddressSerializer < ActiveModel::Serializer
  type :address

  attributes :id,
    :latlng,
    :street_1,
    :street_2,
    :zip_code,
    :city,
    :state,
    :country,
    :contact_name,
    :contact_cellphone,
    :contact_email,
    :telephone,
    :open_hours,
    :notes,
    :gps_coordinates

  belongs_to :institution
end
