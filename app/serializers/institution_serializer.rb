class InstitutionSerializer < Simple::InstitutionSerializer
  has_many :addresses
end
