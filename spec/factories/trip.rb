FactoryBot.define do
  factory :trip do
    transient do
      pickup_schedule({
        start: Faker::Time.forward(1, :morning),
        end: Faker::Time.forward(1, :evening)
      })
      dropoff_schedule({
        start: Faker::Time.forward(1, :morning),
        end: Faker::Time.forward(2, :evening)
      })
    end
    deliveries { create_list(:delivery_with_packages, 3, status: 'assigned') }
    amount { deliveries.sum(&:amount) }
    steps { steps_data(deliveries, pickup_schedule, dropoff_schedule) }

    trait :broadcasted do
      status 'waiting_shipper'

      after(:create) do |trip, evaluator|
        create(:trip_assignment, trip: trip, state: 'broadcasted')
      end
    end

    trait :assigned do
      status 'waiting_shipper'

      after(:create) do |trip, evaluator|
        create(:trip_assignment, trip: trip, state: 'assigned')
      end
    end

    trait :confirmed do
      status 'confirmed'

      after(:create) do |trip, evaluator|
        now = Time.current
        create(:trip_assignment, trip: trip, shipper: trip.shipper, state: 'assigned', closed_at: now)
        create(:trip_assignment, trip: trip, shipper: trip.shipper, state: 'accepted', closed_at: now)
      end
    end

    trait :with_shipper do
      shipper
    end

    trait :created_some_weeks_ago do
      transient do
        number_of_weeks 1
      end

      created_at { number_of_weeks.weeks.ago }
    end

    factory :trip_broadcasted, traits: [ :broadcasted ]
    factory :trip_assigned, traits: [ :assigned ]
    factory :trip_with_shipper, traits: [ :with_shipper, :confirmed ]
  end
end
