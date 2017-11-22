class BankAccount < ApplicationRecord
  belongs_to :shipper
  validates_presence_of :bank_name, :shipper_id

  self.inheritance_column = 'type_of'
end
