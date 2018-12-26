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
    payable_type == 'Order' ? payable.receiver.id : payable.destination_id
  end

  STATUSES.each do |valid_status|
    define_method :"#{valid_status}?" do
      status == valid_status
    end
  end
end
