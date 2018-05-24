class TripAssignment < ApplicationRecord
  attribute :notification_payload, :jsonb, default: {}

  belongs_to :trip
  belongs_to :shipper

  ALLOWED_STATES = %w[
    assigned
    broadcasted
    accepted
    rejected
    expired
  ].freeze
  private_constant :ALLOWED_STATES

  def self.allowed_states
    ALLOWED_STATES
  end
end
