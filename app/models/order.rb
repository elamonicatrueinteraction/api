class Order < ApplicationRecord
  default_scope_by_network
  include Payable

  has_many :deliveries, dependent: :destroy
  has_many :packages, through: :deliveries

  belongs_to :giver, class_name: 'Institution', optional: true
  belongs_to :receiver, class_name: 'Institution', optional: true

  # TODO: Move this to a indexed key outside of the extras, or maybe keep a separate table for mkp
  scope :marketplace, -> { where('orders.extras ->> :key IS NOT NULL', key: :marketplace_order_id) }

  attribute :extras, :jsonb, default: {}

  EXTRA_DATA = %w[
    marketplace_order_id
    delivery_preference
  ].freeze
  private_constant :EXTRA_DATA

  EXTRA_DATA.each do |extra_key|
    define_method :"#{extra_key}" do
      _extras = (self.extras || {})
      _extras[extra_key]
    end

    define_method :"#{extra_key}=" do |new_value|
      self.extras[extra_key] = new_value
    end
  end

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
