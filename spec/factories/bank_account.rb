FactoryBot.define do
  factory :bank_account do
    bank_name { Faker::Bank.name }
    number { Faker::Bank.iban }
    type 'savings'

    shipper
  end
end
