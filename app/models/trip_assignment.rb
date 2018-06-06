class TripAssignment < ApplicationRecord
  attribute :notification_payload, :jsonb, default: {}

  scope :opened, -> { where(closed_at: nil) }
  scope :closed, -> { where('closed_at IS NOT ?', nil) }

  belongs_to :trip
  belongs_to :shipper

  ALLOWED_STATES = %w[
    assigned
    broadcasted
    accepted
    rejected
  ].freeze
  private_constant :ALLOWED_STATES

  def self.allowed_states
    ALLOWED_STATES
  end

  def closed?
    !!closed_at
  end

end
