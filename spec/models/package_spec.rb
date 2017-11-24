require 'rails_helper'

RSpec.describe Package, type: :model do
  it { should belong_to(:delivery) }
  it { should have_one(:order).through(:delivery) }
end
