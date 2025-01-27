class Simple::InstitutionSerializer < ActiveModel::Serializer
  type :institution

  attributes :id,
    :name,
    :legal_name,
    :uid_type,
    :uid,
    :created_at,
    :updated_at,
    :addresses,
    :beneficiaries,
    :offered_services

  belongs_to :district
end
