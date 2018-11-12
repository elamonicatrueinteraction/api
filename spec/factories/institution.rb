FactoryBot.define do
  factory :institution do
    uid_type 'CUIT'
    uid { Faker::Company.cuit }
    offered_services { ['lunch'] }
    beneficiaries { 300 }
    district

    trait :with_address do
      after(:create) do |institution, evaluator|
        create(:address, institution: institution)
      end
    end

    trait :with_users do
      after(:create) do |institution, evaluator|
        create_list(:user_with_profile, Faker::Number.between(1, 3), institution: institution)
      end
    end

    factory :organization do
      name { Faker::Company.ngo_name }
      type 'Institutions::Organization'

      factory :organization_with_address, traits: [ :with_address ]
      factory :organization_with_users, traits: [ :with_users ]
    end

    factory :company do
      name { Faker::Company.name }
      type 'Institutions::Company'

      factory :company_with_address, traits: [ :with_address ]
    end
  end
end
