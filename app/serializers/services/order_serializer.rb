module Service
  class OrderSerializer < ActiveModel::Serializer
    attributes :id,
               :marketplace_order_id,
               :delivery_preference,
               :expiration,
               :amount,
               :bonified_amount,
               :created_at,
               :updated_at,
               :payments

    def payments
      ActiveModelSerializers::SerializableResource.new(
        object.payments,
        { each_serializer: PaymentSerializer }
      ).as_json[:payments]
    end
  end
end
