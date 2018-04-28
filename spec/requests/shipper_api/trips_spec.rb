require 'rails_helper'

RSpec.describe 'Shipper API / Trips Endpoint', type: :request do
  let(:shipper) { create(:shipper_with_vehicle_and_bank_account) }

  describe "GET #index" do
    let!(:trips) { create_list(:trip, 5, shipper: shipper) }
    before { get '/shipper/trips', headers: shipper_auth_headers(shipper) }

    it_behaves_like 'a successful request', :trips
    it { expect(json[:trips].size).to eq(5) }
    it { expect(response).to match_response_schema("trips") }
  end

  describe "GET #show" do
    let(:trip) { create(:trip, shipper: shipper) }

    context 'with valid trip.id' do
      before { get "/shipper/trips/#{trip.id}", headers: shipper_auth_headers(shipper) }

      it_behaves_like 'a successful request', :trip
      it { expect(response).to match_response_schema("trip") }
    end

    context 'with trip.id from other shipper' do
      let(:trip) { create(:trip) }

      before { get "/shipper/trips/#{trip.id}", headers: shipper_auth_headers(shipper) }

      it_behaves_like 'a not_found request'
    end

  end
end
