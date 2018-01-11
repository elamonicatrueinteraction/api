require 'rails_helper'

RSpec.describe 'Authentication Endpoint', type: :request do
  let(:user) { create(:user_with_profile) }

  describe 'POST /authenticate' do
    before { post '/authenticate', params: parameters }

    context 'without user email and password' do
      let(:parameters) { {} }

      it_behaves_like 'a failed request'
    end

    context 'with invalid user email and/or password' do
      let(:parameters) { { email: user.email, password: 'wrongpassword' } }

      it_behaves_like 'a failed request'
    end

    context 'with user email and password' do
      let(:parameters) { { email: user.email, password: user.password } }

      it_behaves_like 'a successful request', :auth_token
    end

  end
end
