require 'rails_helper'

RSpec.describe VerificationsController, type: :request do
  let(:user) { create(:user_with_profile) }

  describe "GET #index" do
    let(:vehicle) { create(:vehicle) }
    let!(:verifications) { create_list(:license_plate_verification, 1, verificable: vehicle) }

    before { get "/vehicles/#{vehicle_id}/verifications", headers: auth_headers(user) }

    context 'with valid vehicle_id' do
      let(:vehicle_id) { vehicle.id }

      it_behaves_like 'a successful request', :verifications
      it { expect(json[:verifications].size).to eq(1) }
      it { expect(response).to match_response_schema("verifications") }
    end

    context 'with invalid vehicle_id' do
      let(:vehicle_id) { SecureRandom.uuid }

      it_behaves_like 'a not_found request'
    end
  end

  describe "POST #create" do
    let(:vehicle) { create(:vehicle) }
    let(:vehicle_id) { vehicle.id }

    before { post "/vehicles/#{vehicle_id}/verifications", headers: auth_headers(user), params: parameters }

    let(:verification_parameters) {
      attributes_for(:license_plate_verification)
    }
    let(:parameters) { verification_parameters }

    context 'with valid data' do
      it_behaves_like 'a successful create request', :verification
      it { expect(response).to match_response_schema("verification") }
      it { expect(Gateway::Shippify::VehicleWorker).to have_enqueued_sidekiq_job(assigns(:current_vehicle).id, 'update') }
      it { expect(Gateway::Shippify::VehicleWorker.jobs.size).to eq(1) }
    end

    context 'with invalid data' do
      let(:parameters) { verification_parameters.merge(type: 'invalid_type') }
      it_behaves_like 'a failed request'
    end

    context 'with invalid vehicle_id' do
      let(:vehicle_id) { SecureRandom.uuid }

      it_behaves_like 'a not_found request'
    end
  end

  describe "PUT/PATCH #update" do
    let(:vehicle) { create(:vehicle) }
    let(:vehicle_id) { vehicle.id }
    let(:verification) { create(:license_plate_verification, verificable: vehicle) }
    let(:verification_id) { verification.id }
    let(:verification_update) { build_stubbed(:license_plate_verification) }

    before { patch "/vehicles/#{vehicle_id}/verifications/#{verification_id}", headers: auth_headers(user), params: parameters }

    let(:verification_parameters) {
      {
        verified: true,
        expire: verification_update.expire,
        expire_at: verification_update.expire_at,
        information: verification_update.information
      }
    }
    let(:parameters) { verification_parameters }

    context 'with valid data' do
      it_behaves_like 'a successful request', :verification
      it { expect(response).to match_response_schema("verification") }
      it { expect(Gateway::Shippify::VehicleWorker).to have_enqueued_sidekiq_job(assigns(:current_vehicle).id, 'update') }
      it { expect(Gateway::Shippify::VehicleWorker.jobs.size).to eq(1) }
    end

    context 'with invalid data' do
      let(:parameters) { verification_parameters.merge(type: 'invalid_type') }

      it_behaves_like 'a failed request'
    end

    context 'with invalid verification_id' do
      let(:verification_id) { Faker::Number.between(50, 100) }

      it_behaves_like 'a not_found request'
    end

    context 'with invalid vehicle_id' do
      let(:vehicle_id) { SecureRandom.uuid }

      it_behaves_like 'a not_found request'
    end
  end

  describe "DELETE #destroy" do
    let(:vehicle) { create(:vehicle) }
    let(:vehicle_id) { vehicle.id }
    let(:verification) { create(:license_plate_verification, verificable: vehicle) }
    let(:verification_id) { verification.id }

    before { delete "/vehicles/#{vehicle_id}/verifications/#{verification_id}", headers: auth_headers(user) }

    context 'with valid verification_id' do
      it_behaves_like 'a successful request', :verification
      it { expect(response).to match_response_schema("verification_id") }
    end

    context 'with invalid verification_id' do
      let(:verification_id) { Faker::Number.between(50, 100) }

      it_behaves_like 'a not_found request'
    end

    context 'with invalid vehicle_id' do
      let(:vehicle_id) { SecureRandom.uuid }

      it_behaves_like 'a not_found request'
    end
  end
end
