FactoryBot.define do
  factory :user do
    username { Faker::Internet.user_name }
    email { Faker::Internet.free_email }
    password { Faker::Internet.password }

    factory :user_with_profile do
      after(:create) do |user, evaluator|
        create(:profile, user: user)
      end
    end
  end
end
