require 'rails_helper'

RSpec.describe BankAccountsController, type: :routing do
  describe 'some REST resources' do
    let(:routes_params){ {} }

    it { expect(get: '/bank_accounts').not_to be_routable }
    it { expect(get: '/bank_accounts/new').to route_to( routes_params.merge(controller: 'v1/bank_accounts', action: 'show', id: 'new') ) }
    it { expect(get: '/bank_accounts/1').to route_to( routes_params.merge(controller: 'v1/bank_accounts', action: 'show', id: '1') ) }
    it { expect(get: '/bank_accounts/1/edit').not_to be_routable }
    it { expect(post: '/bank_accounts').to route_to( routes_params.merge(controller: 'v1/bank_accounts', action: 'create') ) }
    it { expect(put: '/bank_accounts/1').to route_to( routes_params.merge(controller: 'v1/bank_accounts', action: 'update', id: '1') ) }
    it { expect(delete: '/bank_accounts/1').not_to be_routable }

    context 'v1' do
      before { set_accept_header(version: 1) }

      it { expect(get: '/bank_accounts').not_to be_routable }
      it { expect(get: '/bank_accounts/new').to route_to( routes_params.merge(controller: 'v1/bank_accounts', action: 'show', id: 'new') ) }
      it { expect(get: '/bank_accounts/1').to route_to( routes_params.merge(controller: 'v1/bank_accounts', action: 'show', id: '1') ) }
      it { expect(get: '/bank_accounts/1/edit').not_to be_routable }
      it { expect(post: '/bank_accounts').to route_to( routes_params.merge(controller: 'v1/bank_accounts', action: 'create') ) }
      it { expect(put: '/bank_accounts/1').to route_to( routes_params.merge(controller: 'v1/bank_accounts', action: 'update', id: '1') ) }
      it { expect(delete: '/bank_accounts/1').not_to be_routable }
    end
  end

  describe 'some resources under shippers' do
    let(:routes_params){ { shipper_id: '1' } }

    it { expect(get: '/shippers/1/bank_accounts').to route_to( routes_params.merge(controller: 'v1/bank_accounts', action: 'index') ) }
    it { expect(get: '/shippers/1/bank_accounts/new').to route_to( routes_params.merge(controller: 'v1/bank_accounts', action: 'show', id: 'new') ) }
    it { expect(get: '/shippers/1/bank_accounts/1').to route_to( routes_params.merge(controller: 'v1/bank_accounts', action: 'show', id: '1') ) }
    it { expect(get: '/shippers/1/bank_accounts/1/edit').not_to be_routable }
    it { expect(post: '/shippers/1/bank_accounts').to route_to( routes_params.merge(controller: 'v1/bank_accounts', action: 'create') ) }
    it { expect(put: '/shippers/1/bank_accounts/1').to route_to( routes_params.merge(controller: 'v1/bank_accounts', action: 'update', id: '1') ) }
    it { expect(delete: '/shippers/1/bank_accounts/1').not_to be_routable }

    context 'v1' do
      before { set_accept_header(version: 1) }

      it { expect(get: '/shippers/1/bank_accounts').to route_to( routes_params.merge(controller: 'v1/bank_accounts', action: 'index') ) }
      it { expect(get: '/shippers/1/bank_accounts/new').to route_to( routes_params.merge(controller: 'v1/bank_accounts', action: 'show', id: 'new') ) }
      it { expect(get: '/shippers/1/bank_accounts/1').to route_to( routes_params.merge(controller: 'v1/bank_accounts', action: 'show', id: '1') ) }
      it { expect(get: '/shippers/1/bank_accounts/1/edit').not_to be_routable }
      it { expect(post: '/shippers/1/bank_accounts').to route_to( routes_params.merge(controller: 'v1/bank_accounts', action: 'create') ) }
      it { expect(put: '/shippers/1/bank_accounts/1').to route_to( routes_params.merge(controller: 'v1/bank_accounts', action: 'update', id: '1') ) }
      it { expect(delete: '/shippers/1/bank_accounts/1').not_to be_routable }
    end

  end
end
