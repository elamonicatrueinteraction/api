# == Schema Information
#
# Table name: orders
#
#  id              :uuid             not null, primary key
#  giver_id        :uuid
#  receiver_id     :uuid
#  expiration      :date
#  amount          :decimal(12, 4)   default(0.0)
#  bonified_amount :decimal(12, 4)   default(0.0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  extras          :jsonb
#  network_id      :string
#  with_delivery   :boolean
#

require 'rails_helper'

RSpec.describe Order, type: :model do
  it { is_expected.to have_many(:deliveries) }
  it { is_expected.to have_many(:packages).through(:deliveries) }
  it { is_expected.to have_many(:payments) }

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
