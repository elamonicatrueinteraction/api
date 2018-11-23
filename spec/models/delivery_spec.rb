require 'rails_helper'

RSpec.describe Delivery, type: :model do
  it { is_expected.to belong_to(:order) }
  it { is_expected.to belong_to(:trip) }
  it { is_expected.to have_many(:packages) }
  it { is_expected.to have_many(:payments) }

  it { expect(subject.class).to respond_to(:valid_status).with(0).argument }
  it { expect(subject.class).to respond_to(:default_status).with(0).argument }

  it { is_expected.to respond_to(:options).with(0).argument }
  it { is_expected.to respond_to(:options=).with(1).argument }

  it { is_expected.to respond_to(:origin_latlng).with(0).argument }
  it { is_expected.to respond_to(:destination_latlng).with(0).argument }
  it { is_expected.to respond_to(:total_amount).with(0).argument }
  it { is_expected.to respond_to(:is_paid?).with(0).argument }

  context "instance with" do
    context "pending payments" do
      subject { create(:delivery_with_pending_payment) }

      it { expect(subject.is_paid?).to be false }
    end

    context "approved payments" do
      subject { create(:delivery_with_approved_payment) }

      it { expect(subject.is_paid?).to be true }
    end
  end
end
