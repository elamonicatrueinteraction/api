require 'rails_helper'

RSpec.describe DestroyOrder do
  subject(:context) { described_class.call(order) }

  let(:result) { context.result }
  let(:trip) { create(:trip) }

  describe ".call" do

    context 'when the context is successful' do
      let(:order) { create(:order) }

      it 'succeeds' do
        expect(context).to be_success
      end

      describe 'valid result' do
        before { context }

        it { expect(result).to eq(order) }
        it { expect(Order.all).to be_empty }
      end
    end

    context 'when the context is not successful' do
      let(:order) { trip.deliveries.first.order }

      it 'fails' do
        expect(context).to be_failure
      end

      describe 'result is nil' do
        before { context }

        it { expect(result).to be_nil }
        it { expect(Order.all).not_to be_empty }
      end
    end
  end
end
