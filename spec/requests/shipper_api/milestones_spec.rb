require 'rails_helper'

RSpec.describe ShipperApi::MilestonesController, type: :request do
  let(:shipper) { create(:shipper_with_vehicle_and_bank_account) }
  let(:trip) { create(:trip, shipper: shipper) }
  let(:trip_id) { trip.id }

  describe "POST #create" do
    let(:milestone) { build_stubbed(:milestone) }

    let(:milestone_parameters) {
      {
        name: milestone.name,
        latlng: milestone.latlng
      }
    }
    let(:parameters) { milestone_parameters }

    before { post "/shipper/trips/#{trip_id}/milestones", headers: shipper_auth_headers(shipper), params: parameters }

    context 'with valid milestone params' do
      it { expect(Milestone.count).to eq(1) }
      it { expect(trip.milestones).to include(Milestone.first) }

      it_behaves_like 'a successful create request', :milestone
      it { expect(response).to match_response_schema("milestone") }
    end

    context 'with invalid milestone params' do
      let(:parameters) { {} }

      it_behaves_like 'a failed request'
    end

    context 'with trip_id from other shipper' do
      let(:trip) { create(:trip) }

      it_behaves_like 'a not_found request'
    end
  end
end
