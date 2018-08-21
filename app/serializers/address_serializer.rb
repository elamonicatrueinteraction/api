class AddressSerializer < ActiveModel::Serializer
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
    :created_at,
    :updated_at

  belongs_to :institution
end
