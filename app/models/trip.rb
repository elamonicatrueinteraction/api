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

end
