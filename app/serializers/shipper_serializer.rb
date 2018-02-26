class ShipperSerializer < Simple::ShipperSerializer
  attributes :gender,
    :birth_date,
    :phone_num,
    :photo,
    :active,
    :verified,
    :verified_at,
    :national_ids,
    :bank_accounts,
    :gateway,
    :gateway_id,
    :minimum_requirements,
    :requirements

  has_many :vehicles
  has_many :bank_accounts, serializer: Simple::BankAccountSerializer
end
