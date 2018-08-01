require 'rails_helper'

RSpec.describe Payment, type: :model do
  it { is_expected.to belong_to(:payable) }

  it { expect(subject.class).to respond_to(:valid_payment_type?).with(1).argument }

  it { expect(subject.class).to respond_to(:default_payment_type).with(0).argument }
  it { expect(subject.class.default_payment_type).to eq('pagofacil') }

  %w[ pagofacil rapipago ].each do |payment_type|
    it { expect(subject.class.valid_payment_type?(payment_type)).to be true }
  end

  %w[ approved cancelled in_process pending rejected refunded ].each do |status|
    it { is_expected.to respond_to(:"#{status}?").with(0).argument }
  end
end
