require 'rails_helper'

RSpec.describe TripAssignment, type: :model do
  it { is_expected.to belong_to(:shipper) }
  it { is_expected.to belong_to(:trip) }

  it { expect(subject.class).to respond_to(:allowed_states).with(0).argument }
  it { expect(subject.class.allowed_states).to contain_exactly('assigned', 'broadcasted', 'accepted', 'rejected') }

  it { is_expected.to respond_to(:closed?).with(0).argument }
end

