require 'rails_helper'

RSpec.describe AuthenticationController, type: :routing do
  describe 'some actions only allowed' do
    let(:routes_params){ { protocol: 'https' } }

    it { expect(post: '/authenticate').to route_to( routes_params.merge(controller: 'authentication', action: 'authenticate') ) }
  end
end
