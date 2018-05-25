require 'rails_helper'

RSpec.describe CreateTrip do
  subject(:context) { described_class.call(allowed_params) }

  let(:result) { context.result }
  let(:order) { create(:full_order) }
  let(:shipper) { create(:shipper_with_vehicle) }
  let(:shipper_id) { shipper.id }
  let(:order_id) { order.id }

  let(:allowed_params) {
    HashWithIndifferentAccess.new({
      shipper_id: shipper_id,
      comments: '',
      orders_ids: [ order_id ],
      pickup_schedule: {
        start: Faker::Time.forward(1, :morning),
        end: Faker::Time.forward(1, :evening)
      },
      dropoff_schedule: {
        start: Faker::Time.forward(1, :morning),
        end: Faker::Time.forward(2, :evening)
      }
    })
  }

  describe ".call" do
    context 'when the context is successful' do

      it 'succeeds' do
        expect(context).to be_success
      end

      describe 'valid result' do
        let(:trip) { Trip.last }

        before { context }

        it { expect(result).to eq(trip) }
        it { expect(result.deliveries).to eq(order.deliveries) }
        it { expect(result).to be_a(Trip) }
      end
    end

    context 'when the context is not successful because of the shipper' do
      let(:shipper_id) { SecureRandom.uuid }

      it 'fails' do
        expect(context).to be_failure
      end

      describe 'result is nil' do
        before { context }

        it { expect(result).to be_nil }
        it { expect(Trip.all).to be_empty }
      end
    end

    context 'when the context is not successful because of the orders' do
      let(:order_id) { SecureRandom.uuid }

      it 'fails' do
        expect(context).to be_failure
      end

      describe 'result is nil' do
        before { context }

        it { expect(result).to be_nil }
        it { expect(Trip.all).to be_empty }
      end
    end
  end
end
