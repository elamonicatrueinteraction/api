require 'rails_helper'

RSpec.describe Trip, type: :model do
  it { is_expected.to have_many(:deliveries) }
  it { is_expected.to have_many(:packages).through(:deliveries) }
  it { is_expected.to have_many(:orders).through(:deliveries) }

  it { is_expected.to belong_to(:shipper) }
end
