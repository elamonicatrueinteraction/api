class Simple::InstitutionSerializer < ActiveModel::Serializer
  type :institution

  attributes :id,
    :type_name,
    :name,
    :legal_name,
    :uid_type,
    :uid,
    :created_at,
    :updated_at,
    :addresses
end
