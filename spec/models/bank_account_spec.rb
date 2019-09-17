# == Schema Information
#
# Table name: bank_accounts
#
#  id         :uuid             not null, primary key
#  bank_name  :string
#  number     :string
#  type       :string
#  cbu        :string
#  shipper_id :uuid
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  network_id :string
#

require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  it { is_expected.to belong_to(:shipper) }

  it { is_expected.to validate_presence_of(:bank_name) }
  it { is_expected.to validate_presence_of(:number) }
  it { is_expected.to validate_presence_of(:type) }
end
