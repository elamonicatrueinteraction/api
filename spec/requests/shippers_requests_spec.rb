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
        parsed_response = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(parsed_response['data']['email']).to eq(valid_email)
        expect(parsed_response['data']['first_name']).to eq(valid_first_name)
        expect(parsed_response['data']['gateway_id']).to eq(valid_gateway_id)
        expect(parsed_response['data']['last_name']).to eq(valid_last_name)
      end
    end
  end

  describe "PATCH #update" do
    let!(:shipper_id) { Shipper.create!(parameters).id }
    before { patch "/shippers/#{shipper_id}", headers: {Authorization: "Token #{auth_token}"}, params: updated_parameters }
    context 'Update valid shipper' do
      let(:parameters) { {first_name: valid_first_name, last_name: valid_last_name, email: valid_email, gateway_id: valid_gateway_id} }
      let(:updated_parameters) { {first_name: valid_first_name_updated, last_name: valid_last_name_updated, email: valid_email_updated, gateway_id: valid_gateway_id_updated} }
      it "returns valid shipper object" do
        parsed_response = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(parsed_response['data']['email']).to eq(valid_email_updated)
        expect(parsed_response['data']['first_name']).to eq(valid_first_name_updated)
        expect(parsed_response['data']['gateway_id']).to eq(valid_gateway_id_updated)
        expect(parsed_response['data']['last_name']).to eq(valid_last_name_updated)
      end
    end
    context 'Update only valid shipper email' do
      let(:parameters) { {first_name: valid_first_name, last_name: valid_last_name, email: valid_email, gateway_id: valid_gateway_id} }
      let(:updated_parameters) { {email: valid_email_updated} }
      it "returns valid shipper object" do
        parsed_response = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(parsed_response['data']['email']).to eq(valid_email_updated)
        expect(parsed_response['data']['first_name']).to eq(valid_first_name)
        expect(parsed_response['data']['gateway_id']).to eq(valid_gateway_id)
        expect(parsed_response['data']['last_name']).to eq(valid_last_name)
      end
    end
  end
end
