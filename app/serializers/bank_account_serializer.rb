# == Schema Information
#
# Table name: bank_accounts
#
#  id         :uuid             not null, primary key
#  bank_name  :string
#  number     :string
#  type       :string
#  cbu        :string
#  shipper_id :uuid
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  network_id :string
#

class BankAccountSerializer < ActiveModel::Serializer
  attributes :id,
    :bank_name,
    :number,
    :type,
    :cbu,
    :updated_at

  belongs_to :shipper, serializer: Simple::ShipperSerializer
end
