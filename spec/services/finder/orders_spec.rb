require 'rails_helper'

RSpec.describe Finder::Orders do
  subject(:service) { described_class.call(institution: institution) }

  let!(:orders) { create_list(:full_order, 5) }

  describe ".call" do
    context 'with an institution' do
      let(:delivery) { orders.sample.deliveries.sample }
      let(:institution) { delivery.receiver }

      it 'succeeds' do
        expect(service).to be_success
      end

      describe 'valid result' do
        it { expect(service.result).to have(5).item }
      end
    end

    context 'without an institution' do
      let(:institution) { nil }

      it 'succeeds' do
        expect(service).to be_success
      end

      describe 'valid result' do
        it { expect(service.result).to have(5).item }
        it { expect(service.result).to contain_exactly(*orders) }
      end
    end
  end
end
