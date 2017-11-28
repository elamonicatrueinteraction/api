require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  it { is_expected.to belong_to(:shipper) }

  it { is_expected.to validate_presence_of(:bank_name) }
  it { is_expected.to validate_presence_of(:number) }
  it { is_expected.to validate_presence_of(:type) }
  it { is_expected.to validate_presence_of(:shipper) }
end
