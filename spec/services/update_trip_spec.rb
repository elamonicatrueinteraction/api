require 'rails_helper'

RSpec.describe UpdateTrip do
  subject(:context) { described_class.call(trip, allowed_params) }

  let(:result) { context.result }
  let(:trip) { create(:trip) }
  let(:shipper) { create(:shipper_with_vehicle) }
  let(:shipper_id) { shipper.id }
  let(:new_amount) { Faker::Number.between(300, 400) }
  let(:pickup_schedule) { HashWithIndifferentAccess.new({
    start: Faker::Time.forward(5, :morning),
    end: Faker::Time.forward(5, :evening)
  })
  }
  let(:dropoff_schedule) { HashWithIndifferentAccess.new({
    start: Faker::Time.forward(6, :morning),
    end: Faker::Time.forward(6, :evening)
  })
  }
  let(:comments) { 'Some extra comments' }

  describe ".call" do
    context 'when the context is successful' do
      let(:allowed_params) {
        HashWithIndifferentAccess.new({
          shipper_id: shipper_id,
          amount: new_amount,
          comments: comments,
          pickup_schedule: pickup_schedule,
          dropoff_schedule: dropoff_schedule
        })
      }

      it 'succeeds' do
        expect(context).to be_success
      end

      describe 'valid result with all params' do
        before { context }

        it do
          # TO-DO: Review how to solve this issue when try to expect this:
          #
          # expect_any_instance_of(AssignTrip).to receive(:call)
          #
          # Error: Using `any_instance` to stub a method (call) that has been defined on a
          # prepended module (Service::Base) is not supported.

          expect(result).to eq(trip)
          expect(result.shipper).to eq(nil)
          expect(result.comments).to eq(comments)
          expect(result.amount).to eq(new_amount)
          expect(Time.parse(result.pickup_window['start'])).to eq(pickup_schedule[:start])
          expect(Time.parse(result.pickup_window['end'])).to eq(pickup_schedule[:end])
          expect(Time.parse(result.dropoff_window['start'])).to eq(dropoff_schedule[:start])
          expect(Time.parse(result.dropoff_window['end'])).to eq(dropoff_schedule[:end])
        end

      end

      describe 'valid result with new amount only' do
        let(:allowed_params) {
          HashWithIndifferentAccess.new({
            amount: new_amount
          })
        }

        before { context }

        it do
          expect(result.shipper).to eq(nil)
          expect(result.comments).to eq(trip.comments)
          expect(result.amount).to eq(new_amount)
          expect(result.pickup_window).to eq(trip.pickup_window)
          expect(result.dropoff_window).to eq(trip.dropoff_window)
        end
      end

      describe 'valid result with new pickup_schedule only' do
        let(:allowed_params) {
          HashWithIndifferentAccess.new({
            pickup_schedule: pickup_schedule
          })
        }

        before { context }

        it do
          expect(result.shipper).to eq(nil)
          expect(result.comments).to eq(trip.comments)
          expect(result.amount).to eq(trip.amount)
          expect(Time.parse(result.pickup_window['start'])).to eq(pickup_schedule[:start])
          expect(Time.parse(result.pickup_window['end'])).to eq(pickup_schedule[:end])
          expect(Time.parse(result.dropoff_window['start'])).to eq(Time.parse(trip.dropoff_window['start']))
          expect(Time.parse(result.dropoff_window['end'])).to eq(Time.parse(trip.dropoff_window['end']))
        end
      end

      describe 'valid result with new dropoff_schedule only' do
        let(:allowed_params) {
          HashWithIndifferentAccess.new({
            dropoff_schedule: dropoff_schedule
          })
        }

        before { context }

        it do
          expect(result.shipper).to eq(nil)
          expect(result.comments).to eq(trip.comments)
          expect(result.amount).to eq(trip.amount)
          expect(Time.parse(result.pickup_window['start'])).to eq(Time.parse(trip.pickup_window['start']))
          expect(Time.parse(result.pickup_window['end'])).to eq(Time.parse(trip.pickup_window['end']))
          expect(Time.parse(result.dropoff_window['start'])).to eq(dropoff_schedule[:start])
          expect(Time.parse(result.dropoff_window['end'])).to eq(dropoff_schedule[:end])
        end
      end
    end

    context 'when the context is not successful' do
      describe 'with invalid shipper_id' do
        let(:allowed_params) {
          HashWithIndifferentAccess.new({
            shipper_id: SecureRandom.uuid,
            amount: new_amount,
            comments: comments,
            pickup_schedule: pickup_schedule,
            dropoff_schedule: dropoff_schedule
          })
        }

        it 'fails' do
          expect(context).to be_failure
        end

        describe 'result is nil' do
          before { context }

          it { expect(result).to be_nil }
        end
      end

      describe 'with invalid trip status' do
        let(:trip) { create(:trip_with_shipper) }

        let(:allowed_params) {
          HashWithIndifferentAccess.new({
            amount: new_amount,
            comments: comments,
            pickup_schedule: pickup_schedule,
            dropoff_schedule: dropoff_schedule
          })
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
end
