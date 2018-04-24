require 'rails_helper'

RSpec.describe Webhooks::ShippifyController, type: :routing do
  describe 'some specify routes only' do
    let(:routes_params){ { protocol: 'https' } }

    it { expect(get: '/webhooks/shippify/update_delivery').not_to be_routable }
    it { expect(post: '/webhooks/shippify/update_delivery').to route_to( routes_params.merge(controller: 'webhooks/shippify', action: 'update_delivery') ) }
  end
end
