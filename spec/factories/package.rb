FactoryBot.define do
  factory :single_package, class: Package do
    quantity { Faker::Number.between(5, 30) }
    weigth { Faker::Number.decimal(2) }
    volume { Faker::Number.decimal(2) }
    cooling { Faker::Boolean.boolean }
    fragile { Faker::Boolean.boolean }
    description { 'Caja de alimentos' }

    factory :package do
      delivery
    end
  end
end
