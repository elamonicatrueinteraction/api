class Order < ApplicationRecord
  has_many :deliveries, dependent: :destroy
  has_many :packages, through: :deliveries

  belongs_to :giver, class_name: 'Institution'
  belongs_to :receiver, class_name: 'Institution'
end
