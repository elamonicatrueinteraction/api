class Order < ApplicationRecord
  include Payable

  has_many :deliveries, dependent: :destroy
  has_many :packages, through: :deliveries

  belongs_to :giver, class_name: 'Institution', optional: true
  belongs_to :receiver, class_name: 'Institution', optional: true

  attribute :extras, :jsonb, default: {}

  def total_amount
    (amount.to_f - bonified_amount.to_f).to_f
  end

  def is_paid?
    (approved_payments.sum(&:amount).to_f - total_amount) >= 0.0
  end

  private

  def approved_payments
    payments.select(&:approved?)
  end
end
