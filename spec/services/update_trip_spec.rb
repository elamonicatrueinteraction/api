require 'rails_helper'

RSpec.describe UpdateTrip do
  subject(:context) { described_class.call(trip, allowed_params) }

  let(:result) { context.result }
  let(:trip) { create(:trip) }
  let(:shipper) { create(:shipper_with_vehicle) }

  describe ".call" do
    let(:status) { 'in_route' }
    let(:comments) { 'Some extra comments' }

    context 'when the context is successful' do
      let(:allowed_params) {
        HashWithIndifferentAccess.new({ shipper_id: shipper.id, status: status, comments: comments })
      }

      it 'succeeds' do
        expect(context).to be_success
      end

      describe 'valid result' do
        before { context }

        it { expect(result.shipper).to eq(shipper) }
        it { expect(result.status).to eq(status) }
        it { expect(result.comments).to eq(comments) }
      end
    end

    context 'when the context is not successful' do
      let(:allowed_params) {
        HashWithIndifferentAccess.new({ shipper_id: SecureRandom.uuid, status: status, comments: comments })
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
