FactoryBot.define do
  factory :bank_account do
    bank_name { Faker::Bank.name }
    number { Faker::Bank.iban }
    type { 'savings' }
    network_id { 'ROS' }

    shipper
  end
end
