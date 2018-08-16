require 'rails_helper'

RSpec.describe Order, type: :model do
  it { is_expected.to have_many(:deliveries) }
  it { is_expected.to have_many(:packages).through(:deliveries) }
  it { is_expected.to have_many(:payments) }

  it { is_expected.to belong_to(:giver).class_name('Institution') }
  it { is_expected.to belong_to(:receiver).class_name('Institution') }

  it { is_expected.to respond_to(:total_amount).with(0).argument }
  it { is_expected.to respond_to(:is_paid?).with(0).argument }

  context "instance with" do
    context "pending payments" do
      subject { create(:order_with_pending_payment) }

      it { expect(subject.is_paid?).to be false }
    end

    context "approved payments" do
      subject { create(:order_with_approved_payment) }

      it { expect(subject.is_paid?).to be true }
    end
  end
end
