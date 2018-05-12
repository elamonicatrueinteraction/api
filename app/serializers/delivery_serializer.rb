class DeliverySerializer < Simple::DeliverySerializer
  attributes :packages,
    :pickup,
    :dropoff,
    :created_at,
    :updated_at

  belongs_to :origin, class_name: 'Address'
  belongs_to :destination, class_name: 'Address'

  belongs_to :order, serializer: Simple::OrderSerializer
  has_many :payments

  def packages
    object.packages.map do |package|
      package.attributes.slice('id','quantity','weight','volume','cooling','fragile','description')
    end
  end
end



