FactoryBot.define do
  factory :delivery do
    amount { Faker::Number.between(200, 300) }
    bonified_amount { Faker::Number.between(0, 50) }
    order
    origin { order.giver.addresses.first if order }
    origin_gps_coordinates { origin.gps_coordinates if origin }
    destination { order.receiver.addresses.first if order }
    destination_gps_coordinates { destination.gps_coordinates if destination }

    trait :with_packages do
      after(:create) do |delivery, evaluator|
        create_list(:package, Faker::Number.between(1, 5), delivery: delivery)
      end
    end

    factory :delivery_with_packages, traits: [ :with_packages ]
  end
end
