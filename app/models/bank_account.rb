class BankAccount < ApplicationRecord
  belongs_to :shipper
  validates_presence_of :bank_name, :number, :type, :shipper

  self.inheritance_column = 'type_of'
end
