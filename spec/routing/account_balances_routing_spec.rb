require "rails_helper"

RSpec.describe AccountBalancesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/account_balances").to route_to("account_balances#index")
    end

    it "routes to #show" do
      expect(:get => "/account_balances/1").to route_to("account_balances#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/account_balances").to route_to("account_balances#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/account_balances/1").to route_to("account_balances#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/account_balances/1").to route_to("account_balances#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/account_balances/1").to route_to("account_balances#destroy", :id => "1")
    end
  end
end
