# == Schema Information
#
# Table name: trip_assignments
#
#  id                   :bigint           not null, primary key
#  state                :string
#  trip_id              :uuid
#  shipper_id           :uuid
#  created_at           :datetime
#  notification_payload :jsonb
#  notified_at          :datetime
#  closed_at            :datetime
#  network_id           :string
#

class TripAssignment < ApplicationRecord
  default_scope_by_network
  attribute :notification_payload, :jsonb, default: {}

  scope :assigned, -> { where(state: 'assigned') }
  scope :broadcasted, -> { where(state: 'broadcasted') }

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
