require 'rails_helper'

RSpec.describe 'Authentication Endpoint', type: :request do
  let(:user) { create(:user_with_profile) }

  describe 'POST /authenticate' do
    before { post '/authenticate', params: parameters }

    context 'without user email and password' do
      let(:parameters) { {} }

      it 'returns error' do
        expect(json).not_to be_empty
        expect(json.keys).to contain_exactly('errors')
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'with invalid user email and/or password' do
      let(:parameters) { { email: user.email, password: 'wrongpassword' } }

      it 'returns error' do
        expect(json).not_to be_empty
        expect(json.keys).to contain_exactly('errors')
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'with user email and password' do
      let(:parameters) { { email: user.email, password: user.password } }

      it 'returns auth_token' do
        expect(json).not_to be_empty
        expect(json.keys).to contain_exactly('auth_token')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

  end
end
