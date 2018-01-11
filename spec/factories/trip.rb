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
    deliveries { build_list(:delivery_with_packages, 1) }
    amount { deliveries.map(&:amount).sum }
    pickups { deliveries.map{|delivery| location_data(delivery.id, delivery.origin, pickup_schedule) } }
    dropoffs { deliveries.map{|delivery| location_data(delivery.id, delivery.destination, dropoff_schedule) } }

    trait :in_gateway do
      gateway 'Shippify'
      gateway_id 't-nilus-00'
      status 'Broadcasting'
    end

    factory :trip_in_gateway, traits: [ :in_gateway ]
  end
end
