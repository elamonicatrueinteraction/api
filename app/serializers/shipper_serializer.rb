class ShipperSerializer < Simple::ShipperSerializer
  attributes :gender,
    :birth_date,
    :phone_num,
    :photo,
    :active,
    :verified,
    :verified_at,
    :national_ids,
    :bank_account,
    :gateway,
    :gateway_id,
    :minimum_requirements,
    :requirements

  has_many :vehicles, serializer: Simple::VehicleSerializer
end
