require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  it { is_expected.to belong_to(:shipper) }
  it { is_expected.to have_many(:verifications) }

  it { is_expected.to validate_presence_of(:model) }
end
