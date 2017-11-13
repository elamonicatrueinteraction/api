class VerificationSerializer < Simple::VerificationSerializer
  attributes :information, :verified, :responsable, :created_at

  def verified
    object.verified?
  end
end
