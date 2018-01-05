require 'rails_helper'

RSpec.describe OrdersController, type: :routing do
  describe 'some REST resources' do
    let(:routes_params){ { protocol: 'https' } }

    it { expect(get: '/orders').to route_to( routes_params.merge(controller: 'orders', action: 'index') ) }
    it { expect(get: '/orders/new').to route_to( routes_params.merge(controller: 'orders', action: 'show', id: 'new') ) }
    it { expect(get: '/orders/1').to route_to( routes_params.merge(controller: 'orders', action: 'show', id: '1') ) }
    it { expect(get: '/orders/1/edit').not_to be_routable }
    it { expect(post: '/orders').to route_to( routes_params.merge(controller: 'orders', action: 'create') ) }
    it { expect(put: '/orders/1').to route_to( routes_params.merge(controller: 'orders', action: 'update', id: '1') ) }
    it { expect(delete: '/orders/1').to route_to( routes_params.merge(controller: 'orders', action: 'destroy', id: '1') ) }
  end
end
