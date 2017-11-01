require 'rails_helper'
require 'securerandom'

RSpec.describe ShippersController, type: :request do
  let!(:user) { create(:user_with_profile) }
  let(:auth_token) {AuthenticateUser.call(user.email, user.password).result}
  let(:valid_email) {Faker::Internet.safe_email}
  let(:valid_first_name) {Faker::Name.name_with_middle}
  let(:valid_gateway_id) {SecureRandom.uuid}
  let(:valid_last_name) {Faker::Name.last_name}
  let(:valid_email_updated) {"updated_#{valid_email}"}
  let(:valid_first_name_updated) {"Updated #{valid_first_name}"}
  let(:valid_gateway_id_updated) {"updated-#{valid_gateway_id}"}
  let(:valid_last_name_updated) {"Updated #{valid_last_name}"}

  describe "GET #index" do
    before { get '/shippers', headers: {Authorization: "Token #{auth_token}"} }

    context 'Get list of shippers' do
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "POST #create" do
    before { post '/shippers', headers: {Authorization: "Token #{auth_token}"}, params: parameters }

    context 'Create new valid shipper' do
      let(:parameters) { {first_name: valid_first_name, last_name: valid_last_name, email: valid_email, gateway_id: valid_gateway_id} }
      it "returns valid shipper object" do
        expect(response).to have_http_status(:created)
      end
    end

    context 'Create new invalid shipper' do
      let(:parameters) { {first_name: nil, last_name: valid_last_name, email: valid_email, gateway_id: valid_gateway_id} }
      it "returns valid shipper object" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH #update" do
    let(:shipper_id) { Shipper.create!(parameters).id }
    before { patch "/shippers/#{shipper_id}", headers: {Authorization: "Token #{auth_token}"}, params: updated_parameters }

    context 'Update valid shipper' do
      let(:parameters) { {first_name: valid_first_name, last_name: valid_last_name, email: valid_email, gateway_id: valid_gateway_id} }
      let(:updated_parameters) { {first_name: valid_first_name_updated, last_name: valid_last_name_updated, email: valid_email_updated, gateway_id: valid_gateway_id_updated} }
      it "returns valid shipper object" do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'Update only valid shipper email' do
      let(:parameters) { {first_name: valid_first_name, last_name: valid_last_name, email: valid_email, gateway_id: valid_gateway_id} }
      let(:updated_parameters) { {email: valid_email_updated} }
      it "returns valid shipper object" do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'Update invalid shipper' do
      let(:parameters) { {first_name: valid_first_name, last_name: valid_last_name, email: valid_email, gateway_id: valid_gateway_id} }
      let(:updated_parameters) { {first_name: nil, last_name: valid_last_name_updated, email: valid_email_updated, gateway_id: valid_gateway_id_updated} }
      it "returns valid shipper object" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'Update invalid shipper id' do
      let(:shipper_id) { SecureRandom.uuid }
      # let(:parameters) { {first_name: valid_first_name, last_name: valid_last_name, email: valid_email, gateway_id: valid_gateway_id} }
      let(:updated_parameters) { {first_name: valid_first_name_updated, last_name: valid_last_name_updated, email: valid_email_updated, gateway_id: valid_gateway_id_updated} }
      it "returns valid shipper object" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
