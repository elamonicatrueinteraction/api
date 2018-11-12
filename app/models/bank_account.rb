class BankAccount < ApplicationRecord
  self.inheritance_column = 'type_of'

  belongs_to :shipper

  validates_presence_of :bank_name, :number, :type
end
