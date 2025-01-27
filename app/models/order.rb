# == Schema Information
#
# Table name: orders
#
#  id              :uuid             not null, primary key
#  giver_id        :uuid
#  receiver_id     :uuid
#  expiration      :date
#  amount          :decimal(12, 4)   default(0.0)
#  bonified_amount :decimal(12, 4)   default(0.0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  extras          :jsonb
#  network_id      :string
#  with_delivery   :boolean
#

class Order < ApplicationRecord
  default_scope_by_network
  include Payable

  has_many :deliveries, dependent: :destroy
  has_many :packages, through: :deliveries

  def giver
    @giver ||= Services::Institution.find(giver_id)
  end
  attribute :giver

  def receiver
    @receiver ||= Services::Institution.find(receiver_id)
  end

  def type
    "Order"
  end

  def is_type?(suspected_type)
    type == suspected_type
  end

  attribute :receiver

  # TODO: Move this to a indexed key outside of the extras, or maybe keep a separate table for mkp
  scope :marketplace, -> { where('orders.extras ->> :key IS NOT NULL', key: :marketplace_order_id) }
  scope :by_institution_id, ->(id) { where('orders.giver_id = :id OR orders.receiver_id = :id', id: id) }
  scope :by_receiver_id, ->(id) { where('orders.receiver_id = :id', id: id) }

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

  def payer_institution_id
    receiver_id
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
