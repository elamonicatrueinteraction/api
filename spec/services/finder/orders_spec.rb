require 'rails_helper'

RSpec.describe Finder::Orders do
  subject(:service) { described_class.call(institution) }

  let!(:orders) { create_list(:full_order, 5) }

  describe ".call" do
    context 'with an institution' do
      let(:delivery) { orders.sample.deliveries.sample }
      let(:institution) { delivery.receiver }

      it 'succeeds' do
        expect(service).to be_success
      end

      describe 'valid result' do
        # it { expect(service.result).to have(1).item }
        it { expect(service.result).to contain_exactly(delivery.order) }
      end
    end

    context 'without and institution' do
      let(:institution) { nil }

      it 'succeeds' do
        expect(service).to be_success
      end

      describe 'valid result' do
        # it { expect(service.result).to have(5).item }
        it { expect(service.result).to contain_exactly(*orders) }
      end
    end

    context 'with and institution without orders' do
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
