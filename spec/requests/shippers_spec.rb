require 'rails_helper'

RSpec.describe ShippersController, type: :request do
  let(:user) { create(:user_with_profile) }

  describe "GET #index" do
    let!(:shippers) { create_list(:shipper_with_vehicle, 5) }
    before { get '/shippers', headers: auth_headers(user) }

    it_behaves_like 'a successful request', :shippers
    it { expect(json[:shippers].size).to eq(5) }
    it { expect(response).to match_response_schema("shippers") }
  end

  describe "GET #show" do
    let(:shipper) { create(:shipper) }
    before { get "/shippers/#{shipper.id}", headers: auth_headers(user) }

    it_behaves_like 'a successful request', :shipper
    it { expect(response).to match_response_schema("shipper") }
  end

  describe "POST #create" do
    let(:shipper) { build_stubbed(:shipper) }
    before { post '/shippers', headers: auth_headers(user), params: parameters }

    context 'with valid data' do
      let(:parameters) { { first_name: shipper.first_name, last_name: shipper.last_name, email: shipper.email, password: shipper.password, gateway_id: shipper.gateway_id } }

      it_behaves_like 'a successful create request', :shipper
      it { expect(response).to match_response_schema("shipper") }
    end

    context 'with invalid data' do
      let(:parameters) { { first_name: shipper.first_name, last_name: shipper.last_name, email: shipper.email, gateway_id: shipper.gateway_id } }

      it_behaves_like 'a failed request'
    end
  end

  describe "PUT/PATCH #update" do
    let(:shipper) { create(:shipper) }
    let(:shipper_id) { shipper.id }
    let(:shipper_update) { build_stubbed(:shipper) }
    before { patch "/shippers/#{shipper_id}", headers: auth_headers(user), params: parameters }

    context 'only updating the email' do
      let(:parameters) { { email: shipper_update.email } }

      it_behaves_like 'a successful request', :shipper
      it { expect(response).to match_response_schema("shipper") }
      it { expect(Gateway::Shippify::ShipperUpdateWorker).to have_enqueued_sidekiq_job(json[:shipper][:id]) }
      it { expect(Gateway::Shippify::ShipperUpdateWorker.jobs.size).to eq(1) }
    end

    context 'with invalid data' do
      let(:parameters) { { first_name: nil, email: shipper_update.email } }

      it_behaves_like 'a failed request'
    end

    context 'with invalid shipper id' do
      let(:shipper_id) { SecureRandom.uuid }
      let(:parameters) { { email: shipper_update.email } }

      it_behaves_like 'a not_found request'
    end
  end
end
