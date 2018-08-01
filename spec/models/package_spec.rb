require 'rails_helper'

RSpec.describe Package, type: :model do
  it { is_expected.to belong_to(:delivery) }
  it { is_expected.to have_one(:order).through(:delivery) }

  it { is_expected.to respond_to(:size).with(0).argument }
  it { expect(subject.size).to eq('m') }
end
