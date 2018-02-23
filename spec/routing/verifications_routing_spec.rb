require 'rails_helper'

RSpec.describe VerificationsController, type: :routing do
  describe 'no REST to any resource' do
    it { expect(get: '/verifications').not_to be_routable }
    it { expect(get: '/verifications/new').not_to be_routable }
    it { expect(get: '/verifications/1').not_to be_routable }
    it { expect(get: '/verifications/1/edit').not_to be_routable }
    it { expect(post: '/verifications').not_to be_routable }
    it { expect(put: '/verifications/1').not_to be_routable }
    it { expect(delete: '/verifications/1').not_to be_routable }
  end

  describe 'some resources under vehicles' do
    let(:routes_params){ { protocol: 'https', vehicle_id: '1' } }

    it { expect(get: '/vehicles/1/verifications').to route_to( routes_params.merge(controller: 'verifications', action: 'index') ) }
    it { expect(get: '/vehicles/1/verifications/new').not_to be_routable }
    it { expect(get: '/vehicles/1/verifications/1').not_to be_routable }
    it { expect(get: '/vehicles/1/verifications/1/edit').not_to be_routable }
    it { expect(post: '/vehicles/1/verifications').to route_to( routes_params.merge(controller: 'verifications', action: 'create') ) }
    it { expect(put: '/vehicles/1/verifications/1').to route_to( routes_params.merge( controller: 'verifications', action: 'update', id: '1') ) }
    it { expect(delete: '/vehicles/1/verifications/1').to route_to( routes_params.merge(controller: 'verifications', action: 'destroy', id: '1') ) }
  end
end
