require 'rails_helper'

RSpec.describe 'Shipper API / Authentication Endpoint', type: :request do
  let(:shipper) { create(:shipper_with_vehicle_and_bank_account) }

  xdescribe 'POST /shipper/authenticate' do
    before { post '/shipper/authenticate', params: parameters }

    context 'without shipper email and password' do
      let(:parameters) { {} }

      it_behaves_like 'a failed request'
    end

    context 'with invalid shipper email and/or password' do
      let(:parameters) { { email: shipper.email, password: 'wrongpassword' } }

      it_behaves_like 'a failed request'
    end

    context 'with shipper email and password' do
      let(:parameters) { { email: shipper.email, password: shipper.password } }

      it_behaves_like 'a successful request', :auth_token
    end

  end
end
