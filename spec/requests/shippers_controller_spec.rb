require 'rails_helper'

RSpec.describe ShippersController, type: :request do
  let!(:user) { create(:user_with_profile) }
  let(:auth_token) {AuthenticateUser.call(user.email, user.password).result}

  describe "GET #index" do
    before { get '/shippers', headers: {Authorization: "Token #{auth_token}"} }
    context 'Get list of shippers' do
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end
  end
end
