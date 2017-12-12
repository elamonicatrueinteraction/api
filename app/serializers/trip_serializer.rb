class TripSerializer < ActiveModel::Serializer
  attributes :id,
    :status,
    :comments,
    :delivery_amount,
    :package_amount,
    :shipper_name,
    :shipper_avatar_url,
    :pickups,
    :dropoffs,
    :created_at,
    :updated_at

  belongs_to :shipper, serializer: Simple::ShipperSerializer
  has_many :deliveries, serializer: Simple::DeliverySerializer
  has_many :packages

  def delivery_amount
    object.amount.to_f
  end

  def package_amount
    object.orders.flat_map(&:amount).sum
  end

  def shipper_name
    object.shipper.full_name if object.shipper
  end

  def shipper_avatar_url
    ''
  end
end


 # +    shipper_name: 'César Sebastián González',
 # +    shipper_avatar_url: '',
 # +    pickup_start_time: '11-16-2017 09:00',
 # +    pickup_end_time: '11-16-2017 10:00',
 # +    pickup_place: 'Banco de Alimentos de Rosario',
 # +    dropoffs: [
 # +      {
 # +        start_time: '11-16-2017 12:00',
 # +        end_time: '11-16-2017 13:00',
 # +        place: 'Asociación Civil Evita Sol Naciente',
 # +      },
 # +      {
 # +        start_time: '11-16-2017 12:00',
 # +        end_time: '11-16-2017 13:00',
 # +        place: 'Asociación Civil Evita Sol Naciente',
 # +      }
 # +    ],
 # +    delivery_amount: '375.00',
 # +    package_amount: '375.00',
 # +    status: 'on_going',
 # +    package: 'Alimentos no perecederos.',
 # +    comments: 'El timbre no funciona, golpear la puerta.'
