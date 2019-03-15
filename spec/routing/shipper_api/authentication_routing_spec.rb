require 'rails_helper'

RSpec.describe ShipperApi::AuthenticationController, type: :routing do
  describe 'some actions only allowed' do
    let(:routes_params){ {} }

    it { expect(post: '/shipper/authenticate').to route_to( routes_params.merge(controller: 'shipper_api/authentication', action: 'authenticate') ) }
  end
end
