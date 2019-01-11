class Trip < ApplicationRecord
  default_scope_by_network
  attribute :steps, :jsonb, default: []

  attribute :gateway_data, :jsonb, default: {}

  has_many :deliveries, dependent: :nullify
  has_many :milestones, dependent: :destroy
  has_many :orders, through: :deliveries
  has_many :packages, through: :deliveries
  has_many :trip_assignments, dependent: :destroy

  belongs_to :shipper, optional: true

  scope :delivery_at, ->(date) { where("((steps->0)->'schedule'->>'start')::date = ?", date.to_date) }

  ALLOWED_STATUSES = %w[
    waiting_shipper
    confirmed
    canceled
    on_going
    completed
  ].freeze
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
