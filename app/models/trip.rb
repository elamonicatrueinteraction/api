# == Schema Information
#
# Table name: trips
#
#  id           :uuid             not null, primary key
#  shipper_id   :uuid
#  status       :string
#  comments     :string
#  amount       :decimal(12, 4)   default(0.0)
#  gateway      :string
#  gateway_id   :string
#  gateway_data :jsonb
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  steps        :jsonb            not null
#  network_id   :string
#

class Trip < ApplicationRecord
  module Status
    WAITING_SHIPPER = "waiting_shipper"
    CONFIRMED = "confirmed"
    CANCELED = "canceled"
    ON_GOING = "on_going"
    COMPLETED = "completed"
  end
  default_scope_by_network
  attribute :steps, :jsonb, default: []

  attribute :gateway_data, :jsonb, default: {}

  has_many :deliveries, dependent: :nullify
  has_many :milestones, dependent: :destroy
  has_many :orders, through: :deliveries
  has_many :packages, through: :deliveries
  has_many :trip_assignments, dependent: :destroy
  has_many :audits, as: :audited

  belongs_to :shipper, optional: true

  scope :delivery_at, ->(date) { where("((steps->0)->'schedule'->>'start')::date = ?", date.to_date) }

  ALLOWED_STATUSES = [
    Status::WAITING_SHIPPER,
    Status::CONFIRMED,
    Status::CANCELED,
    Status::ON_GOING,
    Status::COMPLETED].freeze
  private_constant :ALLOWED_STATUSES

  def self.allowed_statuses
    ALLOWED_STATUSES
  end

  def pickup_window
    HashWithIndifferentAccess.new(initial_pickup['schedule'])
  end

  def dropoff_window
    HashWithIndifferentAccess.new(last_dropoff['schedule'])
  end

  def net_income
    amount.to_f - deliveries_amount
  end

  private

  def initial_pickup
    @initial_pickup ||= steps.detect{ |step| step['action'] == 'pickup' }
  end

  def last_dropoff
    @last_dropoff ||= steps.reverse.detect{ |step| step['action'] == 'dropoff' }
  end

  def deliveries_amount
    deliveries.sum(&:total_amount).to_f
  end
end
