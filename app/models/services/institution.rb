module Services
  class Institution < Services::UserService
    attributes :id, :name, :legal_name, :city, :category, :uid_type, :uid,
               :created_at, :updated_at, :beneficiaries, :offered_services,
               :network_id, :external_reference, :district

    has_many :users # rubocop:disable Rails/HasManyOrHasOneDependent
    has_many :addresses # rubocop:disable Rails/HasManyOrHasOneDependent
  end
end