require 'rails_helper'

RSpec.describe HomeController, type: :request do
  let(:user) { create(:user_with_profile) }

  describe "GET #show" do

    context 'as an authenticated user' do
      before { get '/', headers: auth_headers(user) }

      it_behaves_like 'a successful request', :message
    end

    context 'as guest' do
      before { get '/' }

      it_behaves_like 'an unauthorized request'
    end

  end
end
