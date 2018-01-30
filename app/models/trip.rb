class Trip < ApplicationRecord
  attribute :steps, :jsonb, default: []

  attribute :gateway_data, :jsonb, default: {}

  has_many :deliveries, dependent: :nullify
  has_many :packages, through: :deliveries
  has_many :orders, through: :deliveries

  belongs_to :shipper, optional: true

  def gateway_setup
    return true if gateway && gateway_id
  end

  def pickup_window
    @pickup_window ||= initial_pickup['schedule']
  end

  def dropoff_window
    @pickup_window ||= last_dropoff['schedule']
  end

  private

  def initial_pickup
    @initial_pickup ||= steps.detect{ |step| step['action'] == 'pickup' }
  end

  def last_dropoff
    @last_dropoff ||= steps.reverse.detect{ |step| step['action'] == 'dropoff' }
  end
end
