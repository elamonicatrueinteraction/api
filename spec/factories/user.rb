FactoryBot.define do
  factory :user do
    username { Faker::Internet.user_name }
    email { Faker::Internet.free_email }
    password { Faker::Internet.password }

    trait :with_profile do
      after(:create) do |user, evaluator|
        create(:profile, user: user)
      end
    end

    factory :user_with_profile, traits: [ :with_profile ]

    factory :authenticated_user do
      with_profile
      token_expire_at { 24.hours.from_now.to_i }
    end

  end
end
