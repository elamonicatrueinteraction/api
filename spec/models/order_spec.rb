require 'rails_helper'

RSpec.describe Order, type: :model do
  it { is_expected.to have_many(:deliveries) }
  it { is_expected.to have_many(:packages).through(:deliveries) }
  it { is_expected.to belong_to(:giver).class_name('Institution') }
  it { is_expected.to belong_to(:receiver).class_name('Institution') }
end
