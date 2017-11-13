class Simple::VerificationSerializer < ActiveModel::Serializer
  attributes :id, :type, :expire, :expire_at
end
