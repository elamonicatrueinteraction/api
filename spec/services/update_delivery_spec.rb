require 'rails_helper'

RSpec.describe UpdateDelivery do
  subject(:context) { described_class.call(delivery, allowed_params) }

  let(:result) { context.result }
  let(:delivery) { create(:delivery) }

  describe ".call" do
    let(:new_amount) { 500 }
    let(:new_destination) { Services::Address.all.sample }

    context 'when the context is successful' do
      let(:allowed_params) {
        HashWithIndifferentAccess.new({ amount: new_amount, destination_id: new_destination.id })
      }

      it 'succeeds' do
        expect(context).to be_success
      end

      describe 'valid result' do
        before { context }

        it { expect(result.amount).to eq(new_amount) }
        it { expect(result.destination).to eq(new_destination) }
      end
    end

    context 'when the context is not successful' do
      let(:allowed_params) {
        HashWithIndifferentAccess.new({ origin_id: 'fake-id' })
      }

      it 'fails' do
        expect(context).to be_failure
      end

      describe 'result is nil' do
        before { context }

        it { expect(result).to be_nil }
      end
    end
  end
end
