require 'rails_helper'

RSpec.describe Delivery, type: :model do
  it { should belong_to(:order) }
  it { should have_many(:packages) }
  it { should belong_to(:origin).class_name('Address') }
  it { should belong_to(:destination).class_name('Address') }
end
