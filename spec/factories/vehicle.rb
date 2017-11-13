FactoryBot.define do
  factory :vehicle do
    brand { Faker::Vehicle.brand }
    model { Faker::Vehicle.model[:"#{brand}"].sample }
    year { Faker::Vehicle.year }
    shipper
  end
end
