require 'rails_helper'

RSpec.describe JobsController, type: :controller do

  describe "GET #sync_coupons" do
    it "returns http success" do
      get :sync_coupons
      expect(response).to have_http_status(:success)
    end
  end

end
