require 'rails_helper'

RSpec.describe DestroyPackage do
  subject(:context) { described_class.call(package) }

  let(:result) { context.result }
  let(:trip) { create(:trip) }

  describe ".call" do

    context 'when the context is successful' do
      let(:package) { create(:package) }

      it 'succeeds' do
        expect(context).to be_success
      end

      describe 'valid result' do
        before { context }

        it { expect(result).to eq(package) }
        it { expect(Package.all).to be_empty }
      end
    end

    context 'when the context is not successful' do
      let(:package) { create(:package, delivery: trip.deliveries.first) }

      it 'fails' do
        expect(context).to be_failure
      end

      describe 'result is nil' do
        before { context }

        it { expect(result).to be_nil }
        it { expect(Package.all).not_to be_empty }
      end
    end
  end
end
