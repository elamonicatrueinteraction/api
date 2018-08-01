FactoryBot.define do
  factory :order do
    amount { Faker::Number.decimal(3, 2) }
    bonified_amount { Faker::Number.number(2) }
    association :giver, factory: :company_with_address
    association :receiver, factory: :organization_with_address

    trait :with_deliveries do
      after(:create) do |order, evaluator|
        create(:delivery, order: order)
      end
    end

    trait :with_full_deliveries do
      after(:create) do |order, evaluator|
        create(:delivery_with_packages, order: order)
      end
    end

    trait :with_pending_payment do
      after(:create) do |order, evaluator|
        create(:payment, payable: order, amount: order.total_amount)
      end
    end

    trait :with_approved_payment do
      after(:create) do |order, evaluator|
        create(:approved_payment, payable: order, amount: order.total_amount)
      end
    end

    factory :order_with_deliveries, traits: [ :with_deliveries ]
    factory :full_order, traits: [ :with_full_deliveries ]

    factory :order_with_pending_payment, traits: [ :with_pending_payment ]
    factory :order_with_approved_payment, traits: [ :with_approved_payment ]
  end
end
