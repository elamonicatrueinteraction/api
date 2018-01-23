require 'rails_helper'

RSpec.describe TripsController, type: :request do
  let(:user) { create(:user_with_profile) }
  let(:shipper) { create(:shipper_with_vehicle_and_bank_account) }
  let(:order) { create(:full_order) }

  describe "GET #index" do
    let!(:trips) { create_list(:trip, 5) }
    before { get '/trips', headers: auth_headers(user) }

    it_behaves_like 'a successful request', :trips
    it { expect(json[:trips].size).to eq(5) }
    it { expect(response).to match_response_schema("trips") }
  end

  describe "GET #show" do
    let(:trip) { create(:trip) }
    before { get "/trips/#{trip.id}", headers: auth_headers(user) }

    it_behaves_like 'a successful request', :trip
    it { expect(response).to match_response_schema("trip") }
  end

  describe "POST #create" do
    let(:trip_parameters) {
      {
        shipper_id: shipper.id,
        comments: 'Some comment',
        orders_ids: [ order.id ],
        pickup_schedule: {
          start: Faker::Time.forward(1, :morning),
          end: Faker::Time.forward(1, :evening)
        },
        dropoff_schedule: {
          start: Faker::Time.forward(1, :morning),
          end: Faker::Time.forward(2, :evening)
        }
      }
    }
    let(:parameters) { trip_parameters }

    before { post '/trips', headers: auth_headers(user), params: parameters }

    context 'with valid data' do
      it_behaves_like 'a successful create request', :trip
      it { expect(Trip.count).to eq(1) }
      it { expect(response).to match_response_schema("trip") }
    end

    context 'with invalid shipper_id' do
      let(:parameters) { trip_parameters.merge(shipper_id: SecureRandom.uuid) }

      it_behaves_like 'a failed request'
      it { expect(Trip.count).to eq(0) }
    end

    context 'with invalid orders_ids' do
      let(:parameters) { trip_parameters.merge(orders_ids: [ SecureRandom.uuid ]) }

      it_behaves_like 'a failed request'
      it { expect(Trip.count).to eq(0) }
    end
  end

  describe "PUT/PATCH #update" do
    let(:trip) { create(:trip) }
    let(:trip_id) { trip.id }

    let(:update_trip_parameters) {
      {
        shipper_id: shipper.id,
        comments: 'Some comment',
        status: 'broadcasting'
      }
    }
    let(:parameters) { update_trip_parameters }

    before { patch "/trips/#{trip_id}", headers: auth_headers(user), params: parameters }

    context 'with valid data' do
      it_behaves_like 'a successful request', :trip
      it { expect(response).to match_response_schema("trip") }
    end

    context 'with invalid data' do
      let(:parameters) { update_trip_parameters.merge(shipper_id: SecureRandom.uuid) }

      it_behaves_like 'a failed request'
    end

    context 'with invalid trip id' do
      let(:trip_id) { SecureRandom.uuid }

      it_behaves_like 'a not_found request'
    end
  end

  describe "DELETE #destroy" do
    let(:trip) { create(:trip) }
    let(:trip_id) { trip.id }

    before { delete "/trips/#{trip_id}", headers: auth_headers(user) }

    context 'with valid data' do
      it_behaves_like 'a successful request', :trip
      it { expect(Trip.count).to eq(0) }
      it { expect(response).to match_response_schema("trip_id") }
    end

    context 'with invalid trip id' do
      let(:trip_id) { SecureRandom.uuid }

      it_behaves_like 'a not_found request'
    end

    context 'with invalid conditions' do
      let(:trip) { create(:trip_in_gateway) }

      it { expect(Trip.count).to eq(1) }
      it_behaves_like 'a failed request'
    end
  end
end
