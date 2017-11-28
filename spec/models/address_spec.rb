require 'rails_helper'

RSpec.describe Address, type: :model do
  it { is_expected.to belong_to(:institution) }

  it { is_expected.to respond_to(:latlng) }

  context "instance with values," do
    subject { build(:organization_address) }

    it 'latlng have to match coordinates' do
      expect(subject.latlng).to eq(subject.gps_coordinates.coordinates.reverse.join(", "))
    end
  end
end
