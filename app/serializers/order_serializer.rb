class OrderSerializer < Simple::OrderSerializer
  has_many :deliveries, serializer: Simple::DeliverySerializer
end
