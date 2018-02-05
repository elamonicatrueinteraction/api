class BankAccountSerializer < ActiveModel::Serializer
  attributes :id,
    :bank_name,
    :number,
    :type,
    :cbu,
    :updated_at

  belongs_to :shipper, serializer: Simple::ShipperSerializer
end
