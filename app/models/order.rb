class Order < ApplicationRecord
  include Payable

  has_many :deliveries, dependent: :destroy
  has_many :packages, through: :deliveries

  belongs_to :giver, class_name: 'Institution', optional: true
  belongs_to :receiver, class_name: 'Institution', optional: true

  def total_amount
    (amount.to_f - bonified_amount.to_f).to_f
  end
end
