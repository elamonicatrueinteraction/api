require 'rails_helper'

RSpec.describe UsersController, type: :request do
  let(:logged_user) { create(:user_with_profile) }

  describe "GET #index" do
    let!(:districts) { create_list(:district, 5) }

    before { get "/districts", headers: auth_headers(logged_user) }

    context 'with valid information' do

      it_behaves_like 'a successful request', :districts
    end
  end
end
