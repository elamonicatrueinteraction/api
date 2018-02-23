class Simple::VehicleSerializer < ActiveModel::Serializer
  attributes :id,
    :model,
    :brand,
    :year,
    :verifications

  def verifications
    object.verifications.map do |verification|
      {
        id: verification.id,
        type: verification.type,
        information: verification.information,
        verified: verification.verified?,
        expired: verification.expired?,
      }.merge(verification.attributes.slice('expire', 'expire_at', 'created_at'))
    end
  end
end
