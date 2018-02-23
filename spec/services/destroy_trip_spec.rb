require 'rails_helper'

RSpec.describe DestroyTrip do
  subject(:context) { described_class.call(trip) }

  let(:result) { context.result }

  describe ".call" do

    context 'when the context is successful' do
      let(:trip) { create(:trip) }

      it 'succeeds' do
        expect(context).to be_success
      end

      describe 'valid result' do
        before { context }

        it { expect(result).to eq(trip) }
        it { expect(Trip.all).to be_empty }
      end
    end

    context 'when the context is not successful' do
      let(:trip) { create(:trip_in_gateway) }

      it 'fails' do
        expect(context).to be_failure
      end

      describe 'result is nil' do
        before { context }

        it { expect(result).to be_nil }
        it { expect(Trip.all).not_to be_empty }
      end
    end
  end
end
