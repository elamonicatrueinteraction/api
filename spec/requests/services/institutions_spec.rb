require 'rails_helper'

RSpec.describe Services::InstitutionsController, type: :request do

  context "with valid token" do
    let(:service_valid_token) { 'SERVICE_VALID_TOKEN' }

    describe "GET #index" do
      let!(:institutions) { create_list(:organization_with_address, 5) }
      before { get '/services/institutions', headers: services_auth_headers(service_valid_token) }

      it_behaves_like 'a successful request', :institutions
      it { expect(json[:institutions].size).to eq(5) }
      it { expect(response).to match_response_schema("institutions") }
    end

    describe "GET #show" do
      let(:institution) { create(:organization_with_address) }
      before { get "/services/institutions/#{institution.id}", headers: services_auth_headers(service_valid_token) }

      it_behaves_like 'a successful request', :institution
      it { expect(response).to match_response_schema("institution") }
    end
  end

  context "with invalid token" do
    let(:service_valid_token) { 'SERVICE_INVALID_TOKEN' }

    describe "GET #index" do
      let!(:institutions) { create_list(:organization_with_address, 5) }
      before { get '/services/institutions', headers: services_auth_headers(service_valid_token) }

      it_behaves_like 'an unauthorized request'
    end

    describe "GET #show" do
      let(:institution) { create(:organization_with_address) }
      before { get "/services/institutions/#{institution.id}", headers: services_auth_headers(service_valid_token) }

      it_behaves_like 'an unauthorized request'
    end
  end

end
