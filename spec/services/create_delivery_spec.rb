require 'rails_helper'

RSpec.describe CreateDelivery do
  subject(:context) { described_class.call(order, allowed_params, within_transaction) }

  let(:result) { context.result }
  let(:order) { create(:order) }
  let(:allowed_params) {
    HashWithIndifferentAccess.new({
      origin_id: origin_id,
      destination_id: destination_id,
      amount: "100",
      bonified_amount: "",
    })
  }

  describe ".call separetly" do
    let(:within_transaction) { false }
    let(:origin_id) { order.giver.addresses.first.id }
    let(:destination_id) { order.receiver.addresses.first.id }

    context 'when the context is successful' do

      it 'succeeds' do
        expect(context).to be_success
      end

      describe 'valid result' do
        let(:delivery) { Delivery.last }

        before { context }

        it { expect(result).to eq(delivery) }
        it { expect(result.order).to eq(delivery.order) }
        it { expect(result).to be_a(Delivery) }
      end
    end

    context 'when the context is not successful' do
      let(:origin_id) { SecureRandom.uuid }
      let(:destination_id) { SecureRandom.uuid }

      it 'fails' do
        expect(context).to be_failure
      end

      describe 'result is nil' do
        before { context }

        it { expect(result).to be_nil }
        it { expect(Delivery.all).to be_empty }
      end
    end
  end

  describe ".call within transaction" do
    let(:within_transaction) { true }
    let(:origin_id) { order.giver.addresses.first.id }
    let(:destination_id) { order.receiver.addresses.first.id }

    context 'when the context is successful' do

      it 'succeeds' do
        expect(context).to be_success
      end

      describe 'valid result' do
        let(:delivery) { Delivery.last }

        before { context }

        it { expect(result).to eq(delivery) }
        it { expect(result).to be_a(Delivery) }
      end
    end

    context 'when the context is not successful' do
      let(:origin_id) { SecureRandom.uuid }
      let(:destination_id) { SecureRandom.uuid }

      it 'raise error' do
        expect{ context }.to raise_error(Service::Error)
      end
      it { expect(Delivery.all).to be_empty }
    end
  end
end
