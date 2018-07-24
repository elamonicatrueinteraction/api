FactoryBot.define do
  factory :trip_assignment do
    trip
    state { 'assigned' }
    shipper
  end
end
