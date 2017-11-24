require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  it { should belong_to(:shipper) }

  it { should validate_presence_of(:bank_name) }
  it { should validate_presence_of(:number) }
  it { should validate_presence_of(:type) }
  it { should validate_presence_of(:shipper) }
end
