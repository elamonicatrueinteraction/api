# == Schema Information
#
# Table name: account_balances
#
#  id             :uuid             not null, primary key
#  institution_id :uuid
#  amount         :decimal(12, 4)   default(0.0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class AccountBalanceSerializer < ActiveModel::Serializer
  attributes :institution_id, :amount, :updated_at
end
