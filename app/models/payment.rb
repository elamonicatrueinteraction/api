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
  module Types
    APPROVED = "approved".freeze
    CANCELLED = "cancelled".freeze
    IN_PROGRESS = "in_progress".freeze
    PENDING = "pending".freeze
    REJECTED = "rejected".freeze
    REFUNDED = "refunded".freeze
    OBSOLETE = "obsolete".freeze
    ERROR = "error".freeze
    EXPIRED = "expired".freeze
  end

  module PaymentTypes
    RAPIPAGO = "rapipago".freeze
    PAGOFACIL = "pagofacil".freeze
    OTRO = "otro".freeze
  end

  validates :amount, numericality: { greater_than_or_equal_to: 0,
                                     message: 'El monto del cupón debe ser mayor o igual a 0' }
  default_scope_by_network
  attribute :gateway_data, :jsonb, default: {}
  attribute :notifications, :jsonb, default: {}

  before_save :approved_state_if_paid
  after_save :update_account_balance


  belongs_to :payable, polymorphic: true

  default_scope { order(created_at: :asc) }

  STATUSES = [ Types::APPROVED, Types::CANCELLED, Types::IN_PROGRESS,
               Types::PENDING, Types::REJECTED, Types::REFUNDED, Types::OBSOLETE].freeze
  private_constant :STATUSES

  PAYMENT_TYPES = [PaymentTypes::RAPIPAGO, PaymentTypes::PAGOFACIL, PaymentTypes::OTRO].freeze
  private_constant :PAYMENT_TYPES

  def self.valid_payment_type?(payment_type_to_check)
    PAYMENT_TYPES.include?(payment_type_to_check.to_s)
  end

  def self.known_payment_status?(status)
    STATUSES.include?(status.to_s)
  end

  def self.default_payment_type
    'pagofacil'
  end

  def payer_institution_id
    payable_type == 'Order' ? payable.receiver_id : payable.destination_id
  end

  def approved_state_if_paid
    self.status = Types::APPROVED if self.collected_amount == self.amount
  end

  def obsolesce
    write_attribute(:status, "obsolete")
  end

  def has_remote?
    !gateway_id.nil?
  end

  def update_account_balance
    institution = payable.receiver
    AccountBalance.update_balance(institution.id)
  end


  STATUSES.each do |valid_status|
    define_method :"#{valid_status}?" do
      status == valid_status
    end
  end
end
