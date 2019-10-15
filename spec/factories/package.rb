FactoryBot.define do
  factory :single_package, class: Package do
    quantity { Faker::Number.between(from: 5, to: 30) }
    weight { Faker::Number.decimal(l_digits: 2) }
    volume { Faker::Number.decimal(l_digits: 2) }
    cooling { Faker::Boolean.boolean }
    fragile { Faker::Boolean.boolean }
    description { 'Caja de alimentos' }
    network_id { 'ROS' }

    factory :package do
      delivery
    end
  end
end
