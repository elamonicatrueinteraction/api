require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  describe 'no REST to any resource' do
    it { expect(get: '/users').not_to be_routable }
    it { expect(get: '/users/new').not_to be_routable }
    it { expect(get: '/users/1').not_to be_routable }
    it { expect(get: '/users/1/edit').not_to be_routable }
    it { expect(post: '/users').not_to be_routable }
    it { expect(put: '/users/1').not_to be_routable }
    it { expect(delete: '/users/1').not_to be_routable }
  end

  describe 'some resources under institutions' do
    let(:routes_params){ { protocol: 'https', institution_id: '1' } }

    it { expect(get: '/institutions/1/users').to route_to( routes_params.merge(controller: 'users', action: 'index') ) }
    it { expect(get: '/institutions/1/users/new').not_to be_routable }
    it { expect(get: '/institutions/1/users/1').not_to be_routable }
    it { expect(get: '/institutions/1/users/1/edit').not_to be_routable }
    it { expect(post: '/institutions/1/users').to route_to( routes_params.merge(controller: 'users', action: 'create') ) }
    it { expect(put: '/institutions/1/users/1').to route_to( routes_params.merge( controller: 'users', action: 'update', id: '1') ) }
    it { expect(delete: '/institutions/1/users/1').to route_to( routes_params.merge(controller: 'users', action: 'destroy', id: '1') ) }
  end
end
