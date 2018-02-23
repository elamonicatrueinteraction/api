FactoryBot.define do
  factory :shipper do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.free_email }
    gateway_id { Faker::Number.number(10) }

    trait :with_vehicle do
      after(:create) do |shipper, evaluator|
        create(:vehicle, shipper: shipper)
      end
    end

    trait :with_bank_account do
      after(:create) do |shipper, evaluator|
        create(:bank_account, shipper: shipper)
      end
    end

    factory :shipper_with_vehicle, traits: [ :with_vehicle ]
    factory :shipper_with_bank_account, traits: [ :with_bank_account ]
    factory :shipper_with_vehicle_and_bank_account, traits: [ :with_vehicle, :with_bank_account ]
  end
end
