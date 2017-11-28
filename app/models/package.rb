class Package < ApplicationRecord
  belongs_to :delivery
  has_one :order, through: :delivery
end
