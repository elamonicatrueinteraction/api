FactoryBot.define do
  factory :address do
    gps_coordinates do
      puts
      puts 'The address factory is deprecated, consider using the address class directly'
      Address::GpsCoordinates.new(
        "POINT(#{Faker::Address.longitude} #{Faker::Address.latitude})"
      )
    end
    coordinates do
      Address::GpsCoordinates.new(
        "POINT(#{Faker::Address.longitude} #{Faker::Address.latitude})"
      )
    end
    street_1  { Faker::Address.street_address }
    street_2  { Faker::Address.secondary_address }
    zip_code  { Faker::Address.zip_code }
    city  { Faker::Address.city }
    state  { Faker::Address.state }
    country  { Faker::Address.country_code }
    contact_name  { Faker::Name.name }
    contact_cellphone  { Faker::PhoneNumber.cell_phone }
    contact_email  { Faker::Internet.free_email }
    telephone  { Faker::PhoneNumber.phone_number }
    open_hours  { Faker::Lorem.sentence(word_count: 3, supplemental: true, random_words_to_add: 4) }
    notes  { Faker::Lorem.sentence }

    trait :for_organization do
      institution_id { Institution.all.sample.id }
    end

    trait :for_company do
      institution_id { Institution.all.sample.id }
    end

    factory :organization_address, traits: [ :for_organization ]
    factory :company_address, traits: [ :for_company ]
  end
end
