class VerificationSerializer < ActiveModel::Serializer
  attributes :id, :type, :information, :verified, :expired, :expire, :expire_at, :responsible, :created_at

  def verified
    object.verified?
  end

  def expired
    object.expired?
  end
end
