require 'rails_helper'

RSpec.describe Services::InstitutionsController, type: :routing do
  describe 'some REST resources' do
    let(:routes_params){ { protocol: 'https' } }

    it { expect(get: '/services/institutions').to route_to( routes_params.merge(controller: 'services/institutions', action: 'index') ) }
    it { expect(get: '/services/institutions/new').to route_to( routes_params.merge(controller: 'services/institutions', action: 'show', id: 'new') ) }
    it { expect(get: '/services/institutions/1').to route_to( routes_params.merge(controller: 'services/institutions', action: 'show', id: '1') ) }
    it { expect(get: '/services/institutions/1/edit').not_to be_routable }
    it { expect(post: '/services/institutions').not_to be_routable }
    it { expect(put: '/services/institutions/1').not_to be_routable }
    it { expect(delete: '/services/institutions/1').not_to be_routable }
  end
end
