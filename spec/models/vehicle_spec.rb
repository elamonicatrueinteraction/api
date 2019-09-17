# == Schema Information
#
# Table name: vehicles
#
#  id         :uuid             not null, primary key
#  shipper_id :uuid
#  model      :string           not null
#  brand      :string
#  year       :integer
#  extras     :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  max_weight :integer
#  network_id :string
#

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
