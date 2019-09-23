class AccountBalanceSerializer < ActiveModel::Serializer
  attributes :institution_id, :amount, :updated_at
end
