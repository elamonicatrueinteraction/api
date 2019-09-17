# == Schema Information
#
# Table name: trip_assignments
#
#  id                   :bigint(8)        not null, primary key
#  state                :string
#  trip_id              :uuid
#  shipper_id           :uuid
#  created_at           :datetime
#  notification_payload :jsonb
#  notified_at          :datetime
#  closed_at            :datetime
#  network_id           :string
#

require 'rails_helper'

RSpec.describe TripAssignment, type: :model do
  it { is_expected.to belong_to(:shipper) }
  it { is_expected.to belong_to(:trip) }

  it { expect(subject.class).to respond_to(:allowed_states).with(0).argument }
  it { expect(subject.class.allowed_states).to contain_exactly('assigned', 'broadcasted', 'accepted', 'rejected') }

  it { is_expected.to respond_to(:closed?).with(0).argument }
end

