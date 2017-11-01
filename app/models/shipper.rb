class Shipper < ApplicationRecord

  validates_presence_of :first_name, :last_name, :email, :gateway_id
end
