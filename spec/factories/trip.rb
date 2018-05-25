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
    shipper
    deliveries { create_list(:delivery_with_packages, 1) }
    amount { deliveries.map(&:amount).sum }
    steps { steps_data(deliveries, pickup_schedule, dropoff_schedule) }

    trait :broadcasted do
      status 'broadcasting'
    end

    trait :created_some_weeks_ago do
      transient do
        number_of_weeks 1
      end

      created_at { number_of_weeks.weeks.ago }
    end

    factory :trip_broadcasted, traits: [ :broadcasted ]
  end
end
