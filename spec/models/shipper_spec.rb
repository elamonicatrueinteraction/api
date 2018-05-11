require 'rails_helper'

RSpec.describe Shipper, type: :model do
  it { is_expected.to have_many(:milestones).through(:trips) }
  it { is_expected.to have_many(:trips) }
  it { is_expected.to have_many(:verifications) }

  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }

end
