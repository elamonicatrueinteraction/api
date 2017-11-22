FactoryBot.define do
  factory :bank_account do
    bank_name { Faker::Name.first_name }
    number { Faker::Number.number(10) }
    type { Faker::Internet.free_email }
    shipper_id { Faker::Number.number(10) }
  end
end
