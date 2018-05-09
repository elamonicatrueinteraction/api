class Simple::DeliverySerializer < ActiveModel::Serializer
  attributes :id,
    :amount,
    :bonified_amount,
    :status,
    :origin_latlng,
    :destination_latlng,
    :options

end
