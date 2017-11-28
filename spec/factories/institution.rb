FactoryBot.define do
  factory :institution do
    uid_type 'CUIT'
    uid { Faker::Company.cuit }
  end

  factory :organization, parent: :institution, class: 'Institutions::Organization' do
    name { Faker::Company.ngo_name }
    type 'organization'
  end

  factory :company, parent: :institution, class: 'Institutions::Company' do
    name { Faker::Company.name }
    type 'company'
  end
end






