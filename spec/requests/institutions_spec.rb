require 'rails_helper'

RSpec.describe InstitutionsController, type: :request do
  let(:user) { create(:user_with_profile) }

  describe "GET #index" do
    let!(:institutions) { create_list(:organization_with_address, 5) }
    before { get '/institutions', headers: auth_headers(user) }

    it_behaves_like 'a successful request', :institutions
    it { expect(json[:institutions].size).to eq(5) }
    it { expect(response).to match_response_schema("institutions") }
  end

  describe "GET #show" do
    let(:institution) { create(:organization_with_address) }
    before { get "/institutions/#{institution.id}", headers: auth_headers(user) }

    it_behaves_like 'a successful request', :institution
    it { expect(response).to match_response_schema("institution") }
  end

  describe "POST #create" do
    let(:institution) { build_stubbed(:organization) }

    let(:institution_parameters) {
      {
        type: 'Organization',
        name: institution.name,
        legal_name: institution.legal_name,
        offered_services: ['lunch'],
        beneficiaries: 300,
        district_id: create(:district).id,
        uid_type: institution.uid_type,
        uid: institution.uid
      }
    }

    before { post '/institutions', headers: auth_headers(user), params: parameters }

    context 'with valid data' do
      let(:parameters) { institution_parameters }

      it_behaves_like 'a successful create request', :institution
      it { expect(response).to match_response_schema("institution") }
    end

    context 'with invalid data' do
      let(:parameters) { institution_parameters.except(:type) }

      it_behaves_like 'a bad_request request'
    end
  end

  describe "PUT/PATCH #update" do
    let(:institution) { create(:organization_with_address) }
    let(:institution_id) { institution.id }
    let(:institution_update) { build_stubbed(:organization) }
    before { patch "/institutions/#{institution_id}", headers: auth_headers(user), params: parameters }

    let(:institution_parameters) {
      {
        name: institution_update.name,
        legal_name: institution_update.legal_name,
        uid_type: institution_update.uid_type,
        uid: institution_update.uid
      }
    }
    let(:parameters) { institution_parameters }

    context 'with valid data' do
      it_behaves_like 'a successful request', :institution
      it { expect(response).to match_response_schema("institution") }
    end

    context 'with invalid data' do
      skip("can't find a way to make it fail")

      # it_behaves_like 'a failed request'
    end

    context 'with invalid institution id' do
      let(:institution_id) { SecureRandom.uuid }

      it_behaves_like 'a not_found request'
    end
  end

  describe "DELETE #destroy" do
    let(:institution) { create(:organization_with_address) }
    let(:institution_id) { institution.id }

    before { delete "/institutions/#{institution_id}", headers: auth_headers(user) }

    context 'with valid institution_id' do
      it_behaves_like 'a successful request', :institution
      it { expect(response).to match_response_schema("institution_id") }
    end

    context 'with invalid institution_id' do
      let(:institution_id) { SecureRandom.uuid }

      it_behaves_like 'a not_found request'
    end
  end
end
