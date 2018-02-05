FactoryBot.define do
  factory :institution do
    uid_type 'CUIT'
    uid { Faker::Company.cuit }

    trait :with_address do
      after(:create) do |institution, evaluator|
        create(:address, institution: institution)
      end
    end

    factory :organization do
      name { Faker::Company.ngo_name }
      type 'Institutions::Organization'

      factory :organization_with_address, traits: [ :with_address ]
    end

    factory :company do
      name { Faker::Company.name }
      type 'Institutions::Company'

      factory :company_with_address, traits: [ :with_address ]
    end
  end
end
