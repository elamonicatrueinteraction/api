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

class BankAccount < ApplicationRecord
  default_scope_by_network
  self.inheritance_column = 'type_of'

  belongs_to :shipper

  validates_presence_of :bank_name, :number, :type
end
