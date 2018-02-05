require 'rails_helper'

RSpec.describe DestroyDelivery do
  subject(:context) { described_class.call(delivery) }

  let(:result) { context.result }
  let(:trip) { create(:trip) }

  describe ".call" do

    context 'when the context is successful' do
      let(:delivery) { create(:delivery_with_packages) }

      it 'succeeds' do
        expect(context).to be_success
      end

      describe 'valid result' do
        before { context }

        it { expect(result).to eq(delivery) }
        it { expect(Delivery.all).to be_empty }
      end
    end

    context 'when the context is not successful' do
      let(:delivery) { trip.deliveries.first }

      it 'fails' do
        expect(context).to be_failure
      end

      describe 'result is nil' do
        before { context }

        it { expect(result).to be_nil }
        it { expect(Delivery.all).not_to be_empty }
      end
    end
  end
end
