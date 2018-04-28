require 'rails_helper'

RSpec.describe Milestone, type: :model do
  it { is_expected.to belong_to(:trip) }
  it { is_expected.to have_one(:shipper).through(:trip) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:gps_coordinates) }

  it { is_expected.to respond_to(:latlng) }

  context "instance with values," do
    subject { build(:milestone) }

    it 'latlng have to match coordinates' do
      expect(subject.latlng).to eq(subject.gps_coordinates.coordinates.reverse.join(","))
    end
  end
end
