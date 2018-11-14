RSpec.shared_context 'an authenticated user' do
  let(:user) { User.where(email: 'dummy@nilus.org').first }
  let(:authorize_user_stubbed) { instance_double(AuthorizeUser) }

  before do
    allow(AuthorizeUser).to receive(:new).and_return(authorize_user_stubbed)
    allow(authorize_user_stubbed).to receive(:call).and_return(authorize_user_stubbed)
    allow(authorize_user_stubbed).to receive(:result).and_return(user)
  end
end
