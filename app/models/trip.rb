class Trip < ApplicationRecord
  attribute :schedule_at, :datetime
  attribute :pickups, :jsonb, default: []
  attribute :dropoffs, :jsonb, default: []

  attribute :gateway_data, :jsonb, default: {}

  has_many :deliveries, dependent: :nullify
  has_many :packages, through: :deliveries
  has_many :orders, through: :deliveries

  belongs_to :shipper, optional: true

  def gateway_setup
    return unless gateway && gateway_id
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
