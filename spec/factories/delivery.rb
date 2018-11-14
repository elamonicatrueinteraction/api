FactoryBot.define do
  factory :delivery do
    amount { Faker::Number.between(200, 300) }
    bonified_amount { Faker::Number.between(0, 50) }
    order
    origin_id { order.giver.addresses.first.id if order&.giver&.addresses }
    origin_gps_coordinates { origin.gps_coordinates if origin }
    destination_id { order.receiver.addresses.first.id if order&.receiver&.addresses }
    destination_gps_coordinates { destination.gps_coordinates if destination }
    status { 'processing' }

    pickup { location_data(origin) if origin }
    dropoff { location_data(destination) if destination }

    trait :with_packages do
      after(:create) do |delivery, evaluator|
        create_list(:package, Faker::Number.between(1, 5), delivery: delivery)
      end
    end

    trait :refrigerated do
      options { [ "refrigerated" ] }
    end

    trait :with_pending_payment do
      after(:create) do |delivery, evaluator|
        create(:payment, payable: delivery, amount: delivery.amount)
      end
    end

    trait :with_approved_payment do
      after(:create) do |delivery, evaluator|
        create(:approved_payment, payable: delivery, amount: delivery.amount)
      end
    end

    factory :delivery_with_packages, traits: [ :with_packages ]
    factory :delivery_with_packages_and_refrigerated, traits: [ :with_packages, :refrigerated ]

    factory :delivery_with_pending_payment, traits: [ :with_pending_payment ]
    factory :delivery_with_approved_payment, traits: [ :with_approved_payment ]
  end
end
