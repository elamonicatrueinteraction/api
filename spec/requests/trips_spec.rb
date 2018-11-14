require 'rails_helper'

RSpec.describe TripsController, type: :request do
  let(:shipper) { create(:shipper_with_vehicle_and_bank_account) }
  let(:order) { create(:full_order) }

  describe "GET #index" do
    include_context 'an authenticated user'
    let!(:trips) { create_list(:trip, 5) }

    context 'direct trips path' do
      context 'without filters' do
        before { get '/trips', headers: auth_headers(user) }

        it_behaves_like 'a successful request', :trips
        it { expect(json[:trips].size).to eq(5) }
        it { expect(response).to match_response_schema("trips") }
      end

      context 'with filters' do
        let!(:one_weeks_trips) { create_list(:trip, 1, :created_some_weeks_ago, number_of_weeks: 1) }
        let!(:three_weeks_trips) { create_list(:trip, 2, :created_some_weeks_ago, number_of_weeks: 3) }

        let(:created_since) { 3.week.ago.to_date.to_s }
        let(:created_until) { 1.week.ago.to_date.to_s }

        before { get "/trips?created_since=#{created_since}&created_until=#{created_until}", headers: auth_headers(user) }

        it_behaves_like 'a successful request', :trips
        it { expect(json[:trips].size).to eq(3) }
        it { expect(response).to match_response_schema("trips") }
      end
    end

    context 'nested under institutions path' do
      let(:institution_id) { trips.sample.orders.sample.receiver_id }

      before { get "/institutions/#{institution_id}/trips", headers: auth_headers(user) }

      context 'with valid institution_id data' do
        it_behaves_like 'a successful request', :trips
        it { expect(json[:trips].size).to eq(5) }
        it { expect(response).to match_response_schema("trips") }
      end

      context 'with invalid institution_id data' do
        let(:institution_id) { SecureRandom.uuid }

        it_behaves_like 'a not_found request'
      end
    end
  end

  describe "GET #show" do
    include_context 'an authenticated user'

    let(:trip) { create(:trip_with_shipper) }
    before { get "/trips/#{trip.id}", headers: auth_headers(user) }

    it_behaves_like 'a successful request', :trip
    it { expect(response).to match_response_schema("trip") }
  end

  describe "POST #create" do
    let(:trip_parameters) {
      {
        shipper_id: shipper.id,
        comments: 'Some comment',
        orders_ids: [create(:full_order).id],
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

    context 'with invalid conditions (broadcasted)' do
      let(:trip) { create(:trip_broadcasted) }

      it { expect(Trip.count).to eq(1) }
      it_behaves_like 'a failed request'
    end

    context 'with invalid conditions (with shipper confirmed)' do
      let(:trip) { create(:trip_with_shipper) }

      it { expect(Trip.count).to eq(1) }
      it_behaves_like 'a failed request'
    end
  end

  describe "POST #pause" do
    let(:trip_id) { trip.id }

    before { post "/trips/#{trip_id}/pause", headers: auth_headers(user), params: {} }

    context 'with valid data' do
      context 'assigned trip' do
        let(:trip) { create(:trip_assigned) }

        it_behaves_like 'a successful request', :trip
        it { expect(Trip.count).to eq(1) }
        it { expect(TripAssignment.opened.count).to eq(0) }
        it { expect(TripAssignment.closed.count).to eq(1) }
        it { expect(trip.reload.status).to eq(nil) }
        it { expect(response).to match_response_schema("trip") }
      end
      context 'broadcasted trip' do
        let(:trip) { create(:trip_broadcasted) }

        it_behaves_like 'a successful request', :trip
        it { expect(Trip.count).to eq(1) }
        it { expect(TripAssignment.opened.count).to eq(0) }
        it { expect(TripAssignment.closed.count).to eq(1) }
        it { expect(trip.reload.status).to eq(nil) }
        it { expect(response).to match_response_schema("trip") }
      end
    end

    context 'with invalid conditions' do
      let(:trip) { create(:trip_with_shipper) }

      it_behaves_like 'a failed request'
      it { expect(Trip.count).to eq(1) }
      it { expect(trip.reload.status).to eq('confirmed') }
    end
  end

  describe "GET #export" do
    let!(:trips) { create_list(:trip, 5) }

    context 'direct trips path' do
      context 'without filters' do
        before { get '/trips/export', headers: auth_headers(user) }

        it 'response status code 200' do
          expect(response).to have_http_status(:success)
        end
      end

      context 'with filters' do
        let!(:one_weeks_trips) { create_list(:trip, 2, :created_some_weeks_ago, number_of_weeks: 1) }

        let(:created_since) { 4.week.ago.to_date.to_s }
        let(:created_until) { 1.week.ago.to_date.to_s }

        before { get "/trips/export?created_since=#{created_since}&created_until=#{created_until}", headers: auth_headers(user) }

        it 'response status code 200' do
          expect(response).to have_http_status(:success)
        end
      end
    end

    context 'nested under institutions path' do
      let(:institution_id) { trips.sample.orders.sample.receiver_id }

      before { get "/institutions/#{institution_id}/trips/export", headers: auth_headers(user) }

      context 'with valid institution_id' do
        it 'response status code 200' do
          expect(response).to have_http_status(:success)
        end
      end

      context 'with invalid institution_id' do
        let(:institution_id) { SecureRandom.uuid }

        it_behaves_like 'a not_found request'
      end
    end
  end
end
