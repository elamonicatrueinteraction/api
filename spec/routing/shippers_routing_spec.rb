require 'rails_helper'

RSpec.describe ShippersController, type: :routing do
  describe 'some REST resources' do
    let(:routes_params){ {} }

    it { expect(get: '/shippers').to route_to( routes_params.merge(controller: 'v1/shippers', action: 'index') ) }
    it { expect(get: '/shippers/new').to route_to( routes_params.merge(controller: 'v1/shippers', action: 'show', id: 'new') ) }
    it { expect(get: '/shippers/1').to route_to( routes_params.merge(controller: 'v1/shippers', action: 'show', id: '1') ) }
    it { expect(get: '/shippers/1/edit').not_to be_routable }
    it { expect(post: '/shippers').to route_to( routes_params.merge(controller: 'v1/shippers', action: 'create') ) }
    it { expect(put: '/shippers/1').to route_to( routes_params.merge(controller: 'v1/shippers', action: 'update', id: '1') ) }
    it { expect(delete: '/shippers/1').not_to be_routable }

    context 'v1' do
      before { set_accept_header(version: 1) }

      it { expect(get: '/shippers').to route_to( routes_params.merge(controller: 'v1/shippers', action: 'index') ) }
      it { expect(get: '/shippers/new').to route_to( routes_params.merge(controller: 'v1/shippers', action: 'show', id: 'new') ) }
      it { expect(get: '/shippers/1').to route_to( routes_params.merge(controller: 'v1/shippers', action: 'show', id: '1') ) }
      it { expect(get: '/shippers/1/edit').not_to be_routable }
      it { expect(post: '/shippers').to route_to( routes_params.merge(controller: 'v1/shippers', action: 'create') ) }
      it { expect(put: '/shippers/1').to route_to( routes_params.merge(controller: 'v1/shippers', action: 'update', id: '1') ) }
      it { expect(delete: '/shippers/1').not_to be_routable }
    end
  end
end
