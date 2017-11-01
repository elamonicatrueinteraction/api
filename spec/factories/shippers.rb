FactoryBot.define do
  require 'securerandom'
  factory :shipper do
    first_name { Faker::Internet.user_name }
    last_name { Faker::Internet.password }
    email { Faker::Internet.free_email }
    gateway_id { SecureRandom.uuid }
  end
end
