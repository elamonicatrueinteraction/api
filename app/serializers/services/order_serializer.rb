module Services
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
      _payments = (object.payments + object.deliveries.map(&:payments).flatten).compact

      ActiveModelSerializers::SerializableResource.new(
        _payments,
        { each_serializer: PaymentSerializer }
      ).as_json[:payments]
    end
  end
end
