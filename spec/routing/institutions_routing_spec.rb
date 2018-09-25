require 'rails_helper'

RSpec.describe InstitutionsController, type: :routing do
  describe 'some REST resources' do
    let(:routes_params){ { protocol: 'https' } }

    it { expect(get: '/institutions').to route_to( routes_params.merge(controller: 'v1/institutions', action: 'index') ) }
    it { expect(get: '/institutions/new').to route_to( routes_params.merge(controller: 'v1/institutions', action: 'show', id: 'new') ) }
    it { expect(get: '/institutions/1').to route_to( routes_params.merge(controller: 'v1/institutions', action: 'show', id: '1') ) }
    it { expect(get: '/institutions/1/edit').not_to be_routable }
    it { expect(post: '/institutions').to route_to( routes_params.merge(controller: 'v1/institutions', action: 'create') ) }
    it { expect(put: '/institutions/1').to route_to( routes_params.merge(controller: 'v1/institutions', action: 'update', id: '1') ) }
    it { expect(delete: '/institutions/1').to route_to( routes_params.merge(controller: 'v1/institutions', action: 'destroy', id: '1') ) }

    context 'v1' do
      before { set_accept_header(version: 1) }

      it { expect(get: '/institutions').to route_to( routes_params.merge(controller: 'v1/institutions', action: 'index') ) }
      it { expect(get: '/institutions/new').to route_to( routes_params.merge(controller: 'v1/institutions', action: 'show', id: 'new') ) }
      it { expect(get: '/institutions/1').to route_to( routes_params.merge(controller: 'v1/institutions', action: 'show', id: '1') ) }
      it { expect(get: '/institutions/1/edit').not_to be_routable }
      it { expect(post: '/institutions').to route_to( routes_params.merge(controller: 'v1/institutions', action: 'create') ) }
      it { expect(put: '/institutions/1').to route_to( routes_params.merge(controller: 'v1/institutions', action: 'update', id: '1') ) }
      it { expect(delete: '/institutions/1').to route_to( routes_params.merge(controller: 'v1/institutions', action: 'destroy', id: '1') ) }
    end
  end
end
