require 'rails_helper'

RSpec.describe Package, type: :model do
  it { is_expected.to belong_to(:delivery) }
  it { is_expected.to have_one(:order).through(:delivery) }
end
