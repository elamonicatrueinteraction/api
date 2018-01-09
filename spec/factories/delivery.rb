FactoryBot.define do
  factory :delivery do
    amount { Faker::Number.between(200, 300) }
    bonified_amount { Faker::Number.between(0, 50) }
    order
    origin { order.giver.addresses.first }
    destination { order.receiver.addresses.first }

    trait :with_packages do
      after(:create) do |delivery, evaluator|
        create_list(:package, Faker::Number.between(1, 5), delivery: delivery)
      end
    end

    factory :delivery_with_packages, traits: [ :with_packages ]
  end
end
