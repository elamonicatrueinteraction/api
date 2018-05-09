require 'rails_helper'

RSpec.describe Finder::Trips do
  subject(:service) { described_class.call(institution) }

  let!(:trips) { create_list(:trip, 5) }

  describe ".call" do
    context 'with an institution' do
      let(:delivery) { trips.sample.deliveries.sample }
      let(:institution) { delivery.receiver }

      it 'succeeds' do
        expect(service).to be_success
      end

      describe 'valid result' do
        # it { expect(service.result).to have(1).item }
        it { expect(service.result).to contain_exactly(delivery.trip) }
      end
    end

    context 'without and institution' do
      let(:institution) { nil }

      it 'succeeds' do
        expect(service).to be_success
      end

      describe 'valid result' do
        # it { expect(service.result).to have(5).item }
        it { expect(service.result).to contain_exactly(*trips) }
      end
    end

    context 'with and institution without trips' do
      let(:institution) { create(:organization) }

      it 'succeeds' do
        expect(service).to be_success
      end

      describe 'valid result' do
        it { expect(service.result).to be_empty }
      end
    end
  end
end
