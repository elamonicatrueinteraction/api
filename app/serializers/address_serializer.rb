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
    :shippify_id,
    :created_at,
    :updated_at

  belongs_to :institution

  def shippify_id
    return unless object.gateway == 'Shippify'

    object.gateway_id
  end
end



