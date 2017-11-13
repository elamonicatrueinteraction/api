FactoryBot.define do
  factory :shipper do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.free_email }
    gateway_id { Faker::Number.number(10) }

    factory :shipper_with_vehicle do
      after(:create) do |shipper, evaluator|
        create(:vehicle, shipper: shipper)
      end
    end
  end
end
