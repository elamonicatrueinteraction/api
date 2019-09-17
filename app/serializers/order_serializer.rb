# == Schema Information
#
# Table name: orders
#
#  id              :uuid             not null, primary key
#  giver_id        :uuid
#  receiver_id     :uuid
#  expiration      :date
#  amount          :decimal(12, 4)   default(0.0)
#  bonified_amount :decimal(12, 4)   default(0.0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  extras          :jsonb
#  network_id      :string
#  with_delivery   :boolean
#

class OrderSerializer < Simple::OrderSerializer
  has_many :deliveries, serializer: Simple::DeliverySerializer

  def giver
    return {} if object.giver.nil?
    ActiveModelSerializers::SerializableResource
        .new(object.giver,{ serializer: Simple::InstitutionSerializer })
        .as_json[:institution]
  end

  def receiver
    return {} if object.giver.nil?
    ActiveModelSerializers::SerializableResource
        .new(object.receiver,{ serializer: Simple::InstitutionSerializer })
        .as_json[:institution]
  end
end
