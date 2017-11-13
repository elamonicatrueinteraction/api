require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  it { should validate_presence_of(:model) }

  it { should belong_to(:shipper) }
  it { should have_many(:verifications) }
end
