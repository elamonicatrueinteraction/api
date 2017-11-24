require 'rails_helper'

RSpec.describe Order, type: :model do
  it { should have_many(:deliveries) }
  it { should have_many(:packages).through(:deliveries) }
  it { should belong_to(:giver).class_name('Institution') }
  it { should belong_to(:receiver).class_name('Institution') }
end
