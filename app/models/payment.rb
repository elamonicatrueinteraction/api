# == Schema Information
#
# Table name: payments
#
#  id               :uuid             not null, primary key
#  status           :string
#  amount           :decimal(10, 2)
#  collected_amount :decimal(10, 2)
#  payable_type     :string
#  payable_id       :string
#  gateway          :string
#  gateway_id       :string
#  gateway_data     :jsonb
#  notifications    :jsonb
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  network_id       :string
#  comment          :string           default("")
#  paid_at          :datetime
#

class Payment < ApplicationRecord
  default_scope_by_network
  attribute :gateway_data, :jsonb, default: {}
  attribute :notifications, :jsonb, default: {}

  belongs_to :payable, polymorphic: true

  default_scope { order(created_at: :asc) }

  STATUSES = %w(
    approved
    cancelled
    in_process
    pending
    rejected
    refunded
    obsolete
  ).freeze
  private_constant :STATUSES

  PAYMENT_TYPES = %w(
    pagofacil
    rapipago
  ).freeze
  private_constant :PAYMENT_TYPES

  def self.valid_payment_type?(payment_type_to_check)
    PAYMENT_TYPES.include?(payment_type_to_check.to_s)
  end

  def self.default_payment_type
    'pagofacil'
  end

  def payer_institution_id
    payable_type == 'Order' ? payable.receiver_id : payable.destination_id
  end

  STATUSES.each do |valid_status|
    define_method :"#{valid_status}?" do
      status == valid_status
    end
  end
end
