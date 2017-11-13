require 'rails_helper'
require 'securerandom'

RSpec.describe ShippersController, type: :request do
  let(:user) { create(:user_with_profile) }
  let(:auth_token) { AuthenticateUser.call(user.email, user.password).result }

  describe "GET #index" do
    let!(:shippers) { create_list(:shipper_with_vehicle, 5) }
    before { get '/shippers', headers: { Authorization: "Token #{auth_token}" } }

    it "returns and array of shippers" do
      expect(json).not_to be_empty
      expect(json.keys).to contain_exactly('shippers')
      expect(json['shippers']).not_to be_empty
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    let(:shipper) { build(:shipper) }
    before { post '/shippers', headers: { Authorization: "Token #{auth_token}" }, params: parameters }

    context 'with valid shipper data' do
      let(:parameters) { { first_name: shipper.first_name, last_name: shipper.last_name, email: shipper.email, gateway_id: shipper.gateway_id } }

      it "returns the created shipper" do
        expect(json).not_to be_empty
        expect(json.keys).to contain_exactly('shipper')
        expect(json['shipper']).not_to be_empty
      end

      it "returns status code 201" do
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid shipper data' do
      let(:parameters) { { first_name: nil, last_name: shipper.last_name, email: shipper.email, gateway_id: shipper.gateway_id } }

      it "returns the errors" do
        expect(json).not_to be_empty
        expect(json.keys).to contain_exactly('error')
        expect(json['error']).not_to be_empty
      end

      it "returns status code 422" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT/PATCH #update" do
    let(:shipper) { create(:shipper) }
    let(:shipper_id) { shipper.id }
    let(:shipper_update) { build(:shipper) }
    before { patch "/shippers/#{shipper_id}", headers: { Authorization: "Token #{auth_token}" }, params: parameters }

    context 'only updating the email' do
      let(:parameters) { { email: shipper_update.email } }

      it "returns the updated shipper" do
        expect(json).not_to be_empty
        expect(json.keys).to contain_exactly('shipper')
        expect(json['shipper']).not_to be_empty
      end

      it "returns status code 200" do
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid data' do
      let(:parameters) { { first_name: nil, email: shipper_update.email } }

      it "returns the errors" do
        expect(json).not_to be_empty
        expect(json.keys).to contain_exactly('error')
        expect(json['error']).not_to be_empty
      end

      it "returns status code 422" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with invalid shipper id' do
      let(:shipper_id) { SecureRandom.uuid }
      let(:parameters) { { email: shipper_update.email } }

      it "returns the errors" do
        expect(json).not_to be_empty
        expect(json.keys).to contain_exactly('error')
        expect(json['error']).not_to be_empty
      end

      it "returns status code 404" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
