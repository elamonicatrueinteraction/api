FactoryBot.define do
  factory :vehicle do
    brand { Faker::Vehicle.make }
    model { Faker::Vehicle.model(make_of_model: brand) }
    year { Faker::Vehicle.year }
    max_weight { Faker::Number.number(digits: 4) }

    shipper
  end
end
