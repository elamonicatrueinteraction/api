require 'rails_helper'

RSpec.describe BankAccountsController, type: :routing do
  describe 'some REST resources' do
    let(:routes_params){ { protocol: 'https' } }

    it { expect(get: '/vehicles').not_to be_routable }
    it { expect(get: '/vehicles/new').not_to be_routable }
    it { expect(get: '/vehicles/1').not_to be_routable }
    it { expect(get: '/vehicles/1/edit').not_to be_routable }
    it { expect(post: '/vehicles').to route_to( routes_params.merge(controller: 'v1/vehicles', action: 'create') ) }
    it { expect(put: '/vehicles/1').to route_to( routes_params.merge(controller: 'v1/vehicles', action: 'update', id: '1') ) }
    it { expect(delete: '/vehicles/1').not_to be_routable }

    context 'v1' do
      before { set_accept_header(version: 1) }

      it { expect(get: '/vehicles').not_to be_routable }
      it { expect(get: '/vehicles/new').not_to be_routable }
      it { expect(get: '/vehicles/1').not_to be_routable }
      it { expect(get: '/vehicles/1/edit').not_to be_routable }
      it { expect(post: '/vehicles').to route_to( routes_params.merge(controller: 'v1/vehicles', action: 'create') ) }
      it { expect(put: '/vehicles/1').to route_to( routes_params.merge(controller: 'v1/vehicles', action: 'update', id: '1') ) }
      it { expect(delete: '/vehicles/1').not_to be_routable }
    end
  end

  describe 'some resources under shippers' do
    let(:routes_params){ { protocol: 'https', shipper_id: '1' } }

    it { expect(get: '/shippers/1/vehicles').to route_to( routes_params.merge(controller: 'v1/vehicles', action: 'index') ) }
    it { expect(get: '/shippers/1/vehicles/new').not_to be_routable }
    it { expect(get: '/shippers/1/vehicles/1').not_to be_routable }
    it { expect(get: '/shippers/1/vehicles/1/edit').not_to be_routable }
    it { expect(post: '/shippers/1/vehicles').to route_to( routes_params.merge(controller: 'v1/vehicles', action: 'create') ) }
    it { expect(put: '/shippers/1/vehicles/1').to route_to( routes_params.merge(controller: 'v1/vehicles', action: 'update', id: '1') ) }
    it { expect(delete: '/shippers/1/vehicles/1').not_to be_routable }

    context 'v1' do
      before { set_accept_header(version: 1) }

      it { expect(get: '/shippers/1/vehicles').to route_to( routes_params.merge(controller: 'v1/vehicles', action: 'index') ) }
      it { expect(get: '/shippers/1/vehicles/new').not_to be_routable }
      it { expect(get: '/shippers/1/vehicles/1').not_to be_routable }
      it { expect(get: '/shippers/1/vehicles/1/edit').not_to be_routable }
      it { expect(post: '/shippers/1/vehicles').to route_to( routes_params.merge(controller: 'v1/vehicles', action: 'create') ) }
      it { expect(put: '/shippers/1/vehicles/1').to route_to( routes_params.merge(controller: 'v1/vehicles', action: 'update', id: '1') ) }
      it { expect(delete: '/shippers/1/vehicles/1').not_to be_routable }
    end
  end
end
