FactoryBot.define do
  VEHICLE_VERIFICATIONS = {
    license_plate: {
      register_date: Faker::Date.between(5.years.ago, 1.year.ago),
      number: "#{Faker::Name.initials(3)}#{Faker::Number.number(3)}",
      state: 'Buenos Aires',
      city: 'AR'
    }
  }.with_indifferent_access.freeze

  factory :verification do
    expire { Faker::Boolean.boolean }
    expire_at { expire ? Faker::Time.forward(365) : nil }

    VEHICLE_VERIFICATIONS.each do |type, information|
      trait "#{type}".to_sym do
        type { type }
        information { information }
      end
      factory "#{type}_verification".to_sym, traits: [ "#{type}".to_sym ]
    end

  end
end
