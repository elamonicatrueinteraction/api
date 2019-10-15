FactoryBot.define do
  factory :vehicle do
    brand { Faker::Vehicle.brand }
    model { Faker::Vehicle.model[:"#{brand}"].sample }
    year { Faker::Vehicle.year }
    max_weight { Faker::Number.number(digits: 4) }

    shipper
  end
end
