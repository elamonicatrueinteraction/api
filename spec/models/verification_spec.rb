require 'rails_helper'

RSpec.describe Verification, type: :model do
  it { is_expected.to belong_to(:verificable) }

  it { is_expected.to respond_to(:type).with(0).argument }
  it { is_expected.to respond_to(:type=).with(1).argument }
  it { is_expected.to respond_to(:information).with(0).argument }
  it { is_expected.to respond_to(:information=).with(1).argument }

  it { is_expected.to respond_to(:verified?).with(0).argument }
  it { is_expected.to respond_to(:expired?).with(0).argument }
  it { is_expected.to respond_to(:responsible).with(0).argument }
end
