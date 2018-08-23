require 'rails_helper'

RSpec.describe Institution, type: :model do
  it { is_expected.to have_many(:addresses) }
  it { is_expected.to have_many(:users) }

  it { expect(subject.class).to respond_to(:valid_types).with(0).argument }
  it { expect(subject.class.valid_types).to contain_exactly('organization', 'company') }

  it { is_expected.to respond_to(:type_name).with(0).argument }
end
