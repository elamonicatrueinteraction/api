class InstitutionSerializer < Simple::InstitutionSerializer
  has_many :addresses
  has_many :users
end
