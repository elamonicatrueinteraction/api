class BankAccount < ApplicationRecord
  default_scope_by_network
  self.inheritance_column = 'type_of'

  belongs_to :shipper

  validates_presence_of :bank_name, :number, :type
end
