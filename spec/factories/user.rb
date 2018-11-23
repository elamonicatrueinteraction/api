FactoryBot.define do
  factory :user do
    username do
      puts
      puts 'The user factory is deprecated, consider using the user class directly'
      Faker::Internet.user_name
    end
    email { Faker::Internet.free_email }
    password { Faker::Internet.password }
    roles { [ :god_admin ] }

    trait :with_profile do
      after(:create) do |user, evaluator|
        create(:profile, user: user)
      end
    end

    trait :authenticated do
      token_expire_at { 24.hours.from_now.to_i }
    end

    trait :for_organization do
      association :institution, factory: [ :organization ]
    end

    factory :user_with_profile, traits: [ :with_profile ]
    factory :authenticated_user, traits: [ :with_profile, :authenticated ]

    factory :organization_user, traits: [ :with_profile, :for_organization ]
  end
end
