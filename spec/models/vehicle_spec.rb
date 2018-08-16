require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  it { is_expected.to belong_to(:shipper) }
  it { is_expected.to have_many(:verifications) }

  it { is_expected.to validate_presence_of(:model) }

  it { expect(subject.class).to be_const_defined(:VERIFICATIONS) }

  it { is_expected.to respond_to(:features).with(0).argument }
  it { is_expected.to respond_to(:features=).with(1).argument }

  %w[ capacity gateway_id ].each do |extras|
    it { is_expected.to respond_to(:"#{extras}").with(0).argument }
    it { is_expected.to respond_to(:"#{extras}=").with(1).argument }
  end
end
