class Simple::BankAccountSerializer < ActiveModel::Serializer
  attributes :id, :bank_name, :number, :type, :cbu
end

