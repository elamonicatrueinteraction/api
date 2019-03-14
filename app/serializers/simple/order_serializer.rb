class Simple::OrderSerializer < ActiveModel::Serializer
  attributes :id,
    :marketplace_order_id,
    :delivery_preference,
    :expiration,
    :amount,
    :bonified_amount,
    :created_at,
    :updated_at,
    :giver,
    :receiver,
    :payments,
    :with_delivery

  def giver
    institution_data(object.giver)
  end

  def receiver
    institution_data(object.receiver)
  end

  def payments
    ActiveModelSerializers::SerializableResource.new(
      object.payments,
      { each_serializer: PaymentSerializer }
    ).as_json[:payments]
  end

  private

  def institution_data(institution)
    return {} unless institution

    {
      id: institution.id,
      name: institution.name
    }
  end
end
