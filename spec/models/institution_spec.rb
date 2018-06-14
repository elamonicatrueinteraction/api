require 'rails_helper'

RSpec.describe Institution, type: :model do
  it { is_expected.to have_many(:addresses) }
  it { is_expected.to have_many(:services) }
  it { is_expected.to have_one(:purchase_group) }

  it { is_expected.to respond_to(:type_name) }
  it { expect(subject.class).to respond_to(:valid_types) }
  it { expect(subject.class.valid_types).to contain_exactly('organization', 'company') }
end
