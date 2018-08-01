require 'rails_helper'

RSpec.describe Trip, type: :model do
  it { is_expected.to belong_to(:shipper) }

  it { is_expected.to have_many(:deliveries) }
  it { is_expected.to have_many(:milestones) }
  it { is_expected.to have_many(:orders).through(:deliveries) }
  it { is_expected.to have_many(:packages).through(:deliveries) }
  it { is_expected.to have_many(:trip_assignments) }

  it { expect(subject.class).to respond_to(:allowed_statuses).with(0).argument }
  it { expect(subject.class.allowed_statuses).to contain_exactly('waiting_shipper', 'confirmed', 'canceled', 'on_going', 'completed') }

  it { is_expected.to respond_to(:pickup_window).with(0).argument }
  it { is_expected.to respond_to(:dropoff_window).with(0).argument }
  it { is_expected.to respond_to(:net_income).with(0).argument }

  context "instance with" do
    context "deliveries" do
      let(:deliveries) { create_list(:delivery_with_packages, 3) }
      let(:deliveries_amount) { deliveries.sum(&:amount) }
      subject { create(:trip, deliveries:deliveries, amount: (deliveries_amount + 50) ) }

      it { expect(subject.net_income).to eq(50) }
    end
  end
end

